#!/usr/bin/env python3

from __future__ import annotations

import filecmp
import os
import shutil
import subprocess
import sys
from pathlib import Path


# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

EFI_ROOT = Path("/efi")
EFI_DIR = EFI_ROOT / "EFI/Microsoft/Boot"

SYSTEMD_BOOT = EFI_ROOT / "EFI/systemd/systemd-bootx64.efi"

BOOTMGFW = EFI_DIR / "bootmgfw.efi"
WINDOWS_BOOT = EFI_DIR / "bootmgfw.real.efi"
WINDOWS_BOOT_BAK = EFI_DIR / "bootmgfw.efi.bak"

TPM_CRYPT_DEVICE = Path("/dev/nvme0n1p4")


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def fail(message: str) -> None:
	print(f"ERROR: {message}", file=sys.stderr)
	sys.exit(1)


def run(*command: str) -> None:
	"""Run a command and abort if it fails."""
	try:
		subprocess.run(command, check=True)
	except subprocess.CalledProcessError as exc:
		fail(
			f"command failed with exit code {exc.returncode}: "
			f"{' '.join(command)}"
		)


def require_file(path: Path, description: str) -> None:
	if not path.is_file():
		fail(f"{description} not found: {path}")


def require_block_device(path: Path, description: str) -> None:
	if not path.exists():
		fail(f"{description} not found: {path}")

	if not path.is_block_device():
		fail(f"{description} is not a block device: {path}")


def is_root() -> bool:
	return os.geteuid() == 0


def elevate() -> None:
	"""Re-execute this script through sudo."""
	print("elevating privileges...")

	script = Path(__file__).resolve()

	os.execvp(
		"sudo",
		["sudo", sys.executable, str(script), *sys.argv[1:]],
	)


def find_efi_files() -> list[Path]:
	"""Return all EFI binaries underneath /efi."""
	files: list[Path] = []

	for root, _, filenames in os.walk(EFI_ROOT):
		for filename in filenames:
			path = Path(root) / filename

			if path.suffix.lower() == ".efi":
				files.append(path)

	return files


# ---------------------------------------------------------------------------
# Bootloader handling
# ---------------------------------------------------------------------------

def patch_bootloader() -> None:
	print("CHECK AND REPLACE WINDOWS BOOTLOADER")
	print()

	require_file(
		SYSTEMD_BOOT,
		"systemd-boot",
	)

	require_file(
		BOOTMGFW,
		"bootmgfw.efi",
	)

	require_file(
		WINDOWS_BOOT,
		"windows bootloader",
	)

	# Compare bootmgfw.efi with systemd-boot.
	if not filecmp.cmp(BOOTMGFW, SYSTEMD_BOOT, shallow=False):
		print("windows bootloader detected.")
		print()

		# Preserve the current Windows bootloader.
		try:
			shutil.copy2(WINDOWS_BOOT, WINDOWS_BOOT_BAK)
		except OSError as exc:
			fail(
				f"failed to create windows bootloader backup: {exc}"
			)

		# Move the current Windows bootloader into the real Windows path.
		try:
			shutil.copy2(BOOTMGFW, WINDOWS_BOOT)
		except OSError as exc:
			fail(
				f"failed to update bootmgfw.real.efi: {exc}"
			)

		# Replace Microsoft's bootloader with systemd-boot.
		try:
			shutil.copy2(SYSTEMD_BOOT, BOOTMGFW)
		except OSError as exc:
			fail(
				f"failed to restore systemd-boot: {exc}"
			)

		print("restored systemd-boot to Microsoft path.")
		print()

		sign_efi_files()
		verify_efi_files()

		print()

	else:
		print("already patched.")


# ---------------------------------------------------------------------------
# Secure Boot
# ---------------------------------------------------------------------------

def sign_efi_files() -> None:
	print("SIGN EFI FILES")
	print()

	for path in find_efi_files():
		print(f"signing {path}")
		run("sbctl", "sign", "-s", str(path))


def verify_efi_files() -> None:
	print()
	print("VERIFY EFI FILES")
	print()

	run("sbctl", "verify")


# ---------------------------------------------------------------------------
# TPM
# ---------------------------------------------------------------------------

def enroll_tpm() -> None:
	answer = input("re-enroll TPM unlock slot? [y/N] ").strip().lower()

	if answer != "y":
		print("skipping TPM enrollment.")
		return

	print()
	print("ADD CRYPT DEVICE TO TPM UNLOCKING")
	print()

	require_block_device(
		TPM_CRYPT_DEVICE,
		"crypt device",
	)

	run(
		"systemd-cryptenroll",
		"--wipe-slot=tpm2",
		str(TPM_CRYPT_DEVICE),
	)

	run(
		"systemd-cryptenroll",
		"--tpm2-device=auto",
		"--tpm2-pcrs=7",
		str(TPM_CRYPT_DEVICE),
	)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
	if not is_root():
		elevate()

	patch_bootloader()
	enroll_tpm()

	print()
	print("DONE")


if __name__ == "__main__":
	try:
		main()
	except KeyboardInterrupt:
		print("\ninterrupted.", file=sys.stderr)
		sys.exit(130)

# #!/usr/bin/env fish
#
# function fail
#     echo "ERROR: $argv" >&2
#     exit 1
# end
#
# if test (id -u) -ne 0
#     echo "elevating privileges..."
#     exec sudo (status filename) $argv
# end
#
# set EFI_DIR /efi/EFI/Microsoft/Boot
# set SYSTEMD_BOOT /efi/EFI/systemd/systemd-bootx64.efi
#
# set BOOTMGFW $EFI_DIR/bootmgfw.efi
# set WINDOWS_BOOT $EFI_DIR/bootmgfw.real.efi
# set WINDOWS_BOOT_BAK $EFI_DIR/bootmgfw.efi.bak
#
# set TPM_CRYPT_DEVICE /dev/nvme0n1p4
#
# echo "CHECK AND REPLACE WINDOWS BOOTLOADER"
# echo ""
#
# test -f "$SYSTEMD_BOOT"; or fail "systemd-boot not found: $SYSTEMD_BOOT"
# test -f "$BOOTMGFW"; or fail "bootmgfw.efi not found: $BOOTMGFW"
# test -f "$WINDOWS_BOOT"; or fail "windows bootloader not found: $WINDOWS_BOOT"
#
# if not cmp -s "$BOOTMGFW" "$SYSTEMD_BOOT"
#     echo "windows bootloader detected."
#
#     cp -f "$WINDOWS_BOOT" "$WINDOWS_BOOT_BAK"; \
#         or fail "failed to create windows bootloader backup"
#
#     cp -f "$BOOTMGFW" "$WINDOWS_BOOT"; \
#         or fail "failed to update bootmgfw.real.efi"
#
#     cp -f "$SYSTEMD_BOOT" "$BOOTMGFW"; \
#         or fail "failed to restore systemd-boot"
#
#     echo "restored systemd-boot to microsoft path."
#
#     echo ""
#     echo "SIGN EFI FILES"
#     echo ""
#
#     for file in (find /efi -type f \( -iname "*.efi" -o -iname "*.EFI" \))
#         echo "signing $file"
#         sbctl sign -s "$file"
#     end
#
#     echo ""
#     echo "VERIFY EFI FILES"
#     echo ""
#
#     sbctl verify; or fail "EFI verification failed"
#
#     echo ""
# else
#     echo "already patched."
# end
#
# read -P "re-enroll TPM unlock slot? [y/N] " answer
#
# if test (string lower -- "$answer") != y
#     echo "skipping TPM enrollment."
#     exit 0
# end
#
# echo ""
# echo "ADD CRYPT DEVICE TO TPM UNLOCKING"
# echo ""
#
# test -b "$TPM_CRYPT_DEVICE"; \
#     or fail "crypt device not found: $TPM_CRYPT_DEVICE"
#
# systemd-cryptenroll --wipe-slot=tpm2 "$TPM_CRYPT_DEVICE"; \
#     or fail "failed to wipe TPM slot"
#
# systemd-cryptenroll \
#     --tpm2-device=auto \
#     --tpm2-pcrs=7 \
#     "$TPM_CRYPT_DEVICE"; \
#     or fail "failed to enroll TPM slot"
#
# echo ""
# echo "DONE"
