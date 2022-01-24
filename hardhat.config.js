//@TODO: re-config the hardhat config 
// ref : https://tek4.vn/khoa-hoc/lap-trinh-nft-su-dung-solidity/trien-khai-nft-qua-16-buoc
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
//const { API_URL,Z_API_URL, PRIVATE_KEY } = process.env;
// module.exports = {
//    solidity: "0.8.0",
//    defaultNetwork: "ropsten",
//    networks: {
//       hardhat: {},
//       ropsten: {
//          url: API_URL,
//          accounts: [`0x${PRIVATE_KEY}`]
//       }
//    },
// }
const {Z_API_URL, PRIVATE_KEY } = process.env;
module.exports = {
   solidity: "0.8.0",
   defaultNetwork: "ropsten",
   networks: {
      hardhat: {},
      ropsten: {
         url: Z_API_URL,
         accounts: [`0x${PRIVATE_KEY}`]
      }
   },
}