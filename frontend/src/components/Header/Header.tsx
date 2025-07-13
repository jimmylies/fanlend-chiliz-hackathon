import FanLend_logo from '@/assets/FanLend_logo.png';
import { Button } from '@/components/ui/button';
import { printAddress } from '@/lib/utils';
import {
  useAppKit,
  useAppKitAccount,
  useDisconnect,
} from '@reown/appkit/react';

const Logo = () => (
  <img src={FanLend_logo} className="h-8" alt="FanLend Logo" />
);

export default function Header() {
  const { open } = useAppKit();
  const { address } = useAppKitAccount();
  const { disconnect } = useDisconnect();
  return (
    <header className="bg-background/95 supports-[backdrop-filter]:bg-background/60 sticky top-0 z-50 flex w-full justify-center border-b px-6 backdrop-blur">
      <div className="container flex h-14 w-full grow items-center justify-between">
        <Logo />
        <div className="flex items-center gap-4">
          {address && printAddress(address)}
          {address ? (
            <Button onClick={() => disconnect()}>Disconnect</Button>
          ) : (
            <Button onClick={() => open()}>Connect Wallet</Button>
          )}
        </div>
      </div>
    </header>
  );
}
