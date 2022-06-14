import React, { useState, useEffect } from 'react';
import getBlockchain from './ethereum'
import './App.css';
import Store from './Store'

function App() {
  // const [paymentProcessor, setPaymentProcessor] = useState();
  // const [vine, setVine] = useState();
  //
  // useEffect(() => {
  //   async function init() {
  //     const { paymentProcessor, vine } = await getBlockchain();
  //     setPaymentProcessor(paymentProcessor);
  //     setVine(vine);
  //   }
  //   init();
  // }, [])

  if(typeof window.ethereum === 'undefined') {
    return (
      <div className="App">
      <header className="App-header">
        <p>
        You need to install metamask.
        </p>
      </header>
      </div>
    );
  }
  return (
    <div className="App">
      <header className="App-header">
        <p>
          Welcome To Rainforest.
        </p>
      </header>
      <Store paymentProcessor={paymentProcessor} vine={vine}/>
    </div>
  );
}

export default App;
