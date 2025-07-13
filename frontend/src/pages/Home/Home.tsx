import { blockInvalidChar } from '@/lib/utils';
import { useState } from 'react';
import { toast } from 'sonner';
import { Button } from '@/components/ui/button';
import './index.scss';

function Home() {
  const [quantity, setQuantity] = useState('');
  const [collateral, setCollateral] = useState<'USDC' | 'ETH'>('USDC');

  const handleButton = (action: 'long' | 'short') => {
    toast.success(
      `A ${action === 'long' ? 'long' : 'short'} position has been opened with ${quantity} ${collateral} collateral for the PSG Fan Token.`
    );
    setQuantity('');
  };
  return (
    <div className="flex grow flex-col items-center p-8">
      <div className="grid grid-cols-2">
        <div className="container mx-auto px-6 py-10">
          <h1 className="mb-8 text-center text-4xl font-extrabold text-gray-900">
            PSG Fan Token Trading Hub
          </h1>

          <section className="intro mb-8 rounded-lg bg-white p-6 shadow-md">
            <p className="mb-4 text-gray-700">
              Welcome to the PSG fan token page.
            </p>
            <p className="text-gray-700">
              Here you’ll be able to long or short the token. Get out your match
              predictions and trade accordingly by taking a long position if you
              think PSG will win, or a short position if you foresee a loss or
              draw.
            </p>
          </section>

          <section className="how-it-works mb-8 rounded-lg bg-white p-6 shadow-md">
            <h2 className="mb-4 text-2xl font-semibold text-gray-800">
              How It Works
            </h2>
            <p className="mb-4 text-gray-700">
              Our protocol lets you speculate on the future value of the Fan
              Tokens. Follow these steps to get started:
            </p>
            <ol className="list-inside list-decimal space-y-3 text-gray-700">
              <li>
                <strong>Deposit collateral:</strong> Supply USDC, ETH, or other
                supported assets to back your position.
              </li>
              <li>
                <strong>Open a trade:</strong> Choose “Long” if you expect the
                token price to rise, or “Short” if you expect it to fall.
              </li>
              <li>
                <strong>Monitor your position:</strong> Track profit & loss in
                real time.
              </li>
              <li>
                <strong>Close or adjust:</strong> Take profit, cut losses, or
                add/remove collateral at any time.
              </li>
            </ol>
          </section>

          <section className="features rounded-lg bg-white p-6 shadow-md">
            <h2 className="mb-4 text-2xl font-semibold text-gray-800">
              Key Features
            </h2>
            <ul className="list-inside list-disc space-y-3 text-gray-700">
              <li>
                <strong>High leverage:</strong> Amplify your exposure up to 5×
                with minimal collateral.
              </li>
              <li>
                <strong>Low fees:</strong> Enjoy competitive borrowing rates and
                zero protocol fees for early adopters.
              </li>
              <li>
                <strong>Real-time data:</strong> Integrated live price feeds and
                order book depth.
              </li>
              <li>
                <strong>Insurance pool:</strong> Safeguard against extreme
                volatility.
              </li>
              <li>
                <strong>Community governance:</strong> Vote on fee changes, new
                token listings, and protocol upgrades.
              </li>
            </ul>
          </section>
        </div>
        <div className="flex items-center justify-center">
          <div className="intro mb-8 flex flex-col gap-2 rounded-lg bg-white p-6 shadow-md">
            <div className="flex items-center gap-2">
              <img
                src="https://asset-metadata-service-production.s3.amazonaws.com/asset_icons/b8daa4530f0e5039a0e4e57f63aad2374cb099b38062174299208337a2d7e1f4.png"
                alt="PSG Logo"
                className="h-16"
              />
              <div className="flex flex-col">
                <h1 className="text-2xl font-semibold">
                  Paris Saint-Germain Fan Token
                </h1>
                <span className="text-lg font-bold">PSG</span>
              </div>
            </div>
            <div className="flex flex-col gap-1">
              <span className="text-lg font-medium">
                Select your collateral:
              </span>
              <div className="flex items-center gap-2">
                <Button
                  variant={collateral === 'USDC' ? 'default' : 'ghost'}
                  onClick={() => setCollateral('USDC')}
                  size={'lg'}
                >
                  USDC
                </Button>
                <Button
                  variant={collateral === 'ETH' ? 'default' : 'ghost'}
                  onClick={() => setCollateral('ETH')}
                  size={'lg'}
                >
                  ETH
                </Button>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <input
                type="number"
                inputMode="decimal"
                autoComplete="off"
                autoCorrect="off"
                placeholder="0.0"
                step="any"
                min={0}
                value={quantity}
                onChange={e => setQuantity(e.target.value)}
                onKeyDown={blockInvalidChar}
                onWheel={e => (e.target as HTMLInputElement).blur()}
                className={'className'}
              />
              <span className="text-lg font-medium">
                {collateral === 'USDC' ? 'USDC' : 'ETH'}
              </span>
            </div>
            <span className="text-sm text-gray-500">
              You are opening a position with{' '}
              {collateral === 'USDC' ? 'USDC' : 'ETH'} collateral for the PSG
              Fan Token.
            </span>
            <div className="flex gap-2">
              <button
                onClick={() => handleButton('long')}
                className="w-full rounded bg-green-500 p-2 text-white"
                disabled={!quantity || parseFloat(quantity) <= 0}
              >
                Long
              </button>
              <button
                onClick={() => handleButton('short')}
                className="w-full rounded bg-red-500 p-2 text-white"
                disabled={!quantity || parseFloat(quantity) <= 0}
              >
                Short
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Home;
