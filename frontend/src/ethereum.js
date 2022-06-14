import { ethers } from 'ethers';
import PaymentProcessor from './contracts/PaymentProcessor.json';
import Vine from './contracts/Vine.json';


async function getBlockchain() {
  new Promise((resolve, reject) => {
    window.addEventListener('load', async () => {
      if(window.ethereum) {
        // await window.ethereum.request('eth_requestAccounts');
        // await window.ethereum.enable();
        await window.ethereum.request({ method: 'eth_requestAccounts' })
                      // .then(handleAccountsChanged)
                      // .catch(function(err) {
                      //   if (err.code === 4001) {
                      //     // EIP-1193 userRejectedRequest error
                      //     // If this happens, the user rejected the connection request.
                      //     console.log('Please connect to MetaMask.');
                      //   } else {
                      //     console.error(err);
                      //   }
                      // }

        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();

        // console.log(PaymentProcessor.networks[window.ethereum.networkVersion].address)
        // console.log(PaymentProcessor.abi)
        // console.log(signer)
        const paymentProcessor = new ethers.Contract(
          PaymentProcessor.networks[window.ethereum.networkVersion].address,
          PaymentProcessor.abi,
          signer
        );

        const vine = new ethers.Contract(
          Vine.networks[window.ethereum.networkVersion].address,
          Vine.abi,
          signer
        );

        resolve({provider, paymentProcessor, vine});
      }
      resolve({provider: undefined, paymentProcessor: undefined, vine: undefined})
    })
  })
}

export default getBlockchain;
