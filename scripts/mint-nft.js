require("dotenv").config()
const API_URL = process.env.API_URL
const PUBLIC_KEY = process.env.PUBLIC_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY

const { createAlchemyWeb3 } = require("@alch/alchemy-web3")
const web3 = createAlchemyWeb3(API_URL)
//contract ABI – application binary interface, the hardhat will compile the KemNFT and store the info into the KemNFT.json
const kem_contract = require("../artifacts/contracts/KemNFT.sol/KemNFT.json")
//log the info
console.log(JSON.stringify(kem_contract.abi))
//contract address when deploy
const contractAddress = "0xf8Df2bc5d528b934bcb318f676b7813aD370e47A"
//create nft contrct from this address by web3
const nftContract = new web3.eth.Contract(kem_contract.abi, contractAddress)
//function 'mintNFT' to deliver the file on pinata to ETH network
async function mintNFT(tokenURI) {
    const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest'); //get latest nonce

    //the transaction info
    const tx = {
      'from': PUBLIC_KEY,
      'to': contractAddress,
      'nonce': nonce,
      'gas': 500000,
      'data': nftContract.methods.mintNFT(PUBLIC_KEY, tokenURI).encodeABI()
    };
    //sign the transaction
    const signPromise = web3.eth.accounts.signTransaction(tx, PRIVATE_KEY)
    signPromise
    .then((signedTx) => {
      web3.eth.sendSignedTransaction(
        signedTx.rawTransaction,
        function (err, hash) {
          if (!err) {
            console.log(
              "The hash of your transaction is: ",
              hash,
              "\nCheck Alchemy's Mempool to view the status of your transaction!"
            )
          } else {
            console.log(
              "Something went wrong when submitting your transaction:",
              err
            )
          }
        }
      )
    })
    .catch((err) => {
      console.log(" Promise failed:", err)
    })
}
//excute the 'mintNFT' with param is the url of he ipfs file metadata json from the ipfs
mintNFT(
    "https://gateway.pinata.cloud/ipfs/QmX42j7GSvAd1gsempZfAYyc8cgM3rxJ874LfUZn5K5V1h"
)