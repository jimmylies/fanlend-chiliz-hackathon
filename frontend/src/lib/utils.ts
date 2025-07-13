import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function printAddress(address: string | null): string {
  if (!address) return 'Not connected';
  return `${address.slice(0, 6)}...${address.slice(-4)}`;
}

export function blockInvalidChar(
  e: React.KeyboardEvent,
  additionalString: string[] = ['']
) {
  ['e', 'E', '+', '-'].concat(additionalString).includes(e.key) &&
    e.preventDefault();
}
