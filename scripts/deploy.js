//content of the 'main' function
async function main() {
    const KemNFT = await ethers.getContractFactory("KemNFT")
  
    // Start deployment, returning a promise that resolves to a contract object
    const kem_nft = await KemNFT.deploy()
    console.log("Contract deployed to address:", kem_nft.address)
}
//excute the 'main' function  
main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })