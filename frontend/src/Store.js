import React from 'react';
import { ethers } from 'ethers';
import axios from 'axios';
const { paymentProcessor, vine } = await getBlockchain();

const API_URL = 'http://localhost:3001'


class Store extends React.Component {

  constructor(props){
    super(props);
    const [p, v] = await getBlockchain();
    this.state = {orderTypes: [
        {
          id: 1,
          price: '200',
          quantity: 1
        },
        {
          id: 2,
          price: '100',
          quantity: 3
        },
      ],
      paymentProcessor: p,
      vine: v
    };
  }
  // console.log(ethers.utils.parseEther('200'))
  async function buy(item) => {
    // const response1 = await axios.get(`${API_URL}/api`);
    console.log(item)
    const etherVal = ethers.utils.parseEther('200');
    const tx = await paymentProcessor.pay(etherVal, 16, 16, 18, 50);
    await tx.wait();
  };

  // var rows = orderTypes.map((orderType) => {
  //   <li className='list-group-item' key={orderType.id}>{orderType.quantity} Bags: {orderType.price}
  //     <button
  //       type='button'
  //       className='btn btn-primary float-right'
  //       onClick={() => buy(orderType.id)}
  //     >Buy</button>
  //   </li>
  // });

  render() {
    var rows = []
    for (var i = 0; i < orderTypes.length; i++) {
      rows.push(
        <li className='list-group-item' key={orderTypes[i]['id']} >
        {orderTypes[i]['quantity']} Bags: {orderTypes[i]['price']} eth
        <button
        type='button'
        className='btn btn-primary float-right'
        onClick={function() {buy(orderTypes[i])}}
        >Buy</button>
        </li>
      )
    };

    return (
      <ul className='list-group'>
      {rows}
      </ul>
    )
  }
}

export default Store
