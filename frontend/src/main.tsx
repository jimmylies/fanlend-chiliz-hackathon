import React from 'react';
import { createRoot } from 'react-dom/client';
import { createAppKit } from '@reown/appkit/react';
import { WagmiProvider } from 'wagmi';
import {
  arbitrum,
  mainnet,
  AppKitNetwork,
  spicy,
} from '@reown/appkit/networks';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { WagmiAdapter } from '@reown/appkit-adapter-wagmi';

import { initResponsive } from './lib/responsive.ts';
import AppRouter from './AppRouter.tsx';
import config from './config/index.ts';
import './index.css';

initResponsive();

const queryClient = new QueryClient();
const projectId = config.WALLET_CONNECT_PROJECT_ID;
const metadata = config.WALLET_CONNECT_METADATA;
const networks: [AppKitNetwork, ...AppKitNetwork[]] = [spicy];

const wagmiAdapter = new WagmiAdapter({
  networks,
  projectId,
  ssr: true,
});

createAppKit({
  adapters: [wagmiAdapter],
  networks,
  projectId,
  metadata,
  features: {
    analytics: true,
  },
});

createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <WagmiProvider config={wagmiAdapter.wagmiConfig}>
      <QueryClientProvider client={queryClient}>
        <AppRouter />
      </QueryClientProvider>
    </WagmiProvider>
  </React.StrictMode>
);
