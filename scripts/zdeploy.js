//content of the 'main' function
async function main() {
    const ZombieNFT = await ethers.getContractFactory("ZombieOwnership")
  
    // Start deployment, returning a promise that resolves to a contract object
    const zombie_nft = await ZombieNFT.deploy()
    console.log("Contract deployed to address:", zombie_nft.address)
}
//excute the 'main' function  
main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })