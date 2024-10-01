import { ethers } from "ethers";
import fs from "fs-extra";
import dotenv from "dotenv";

const main = async () => {
    dotenv.config();
    const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
    // const wallet = new ethers.Wallet(
    //     process.env.PRIVATE_KEY,
    //     provider
    // );
    const encyptedJson = fs.readFileSync("./encryptedKey.json", "utf8");
    console.log(encyptedJson)
    let wallet = ethers.Wallet.fromEncryptedJsonSync(encyptedJson, process.env.PRIVATE_KEY_PASSWORD!);
    wallet = wallet.connect(provider);
    
    const abi = fs.readFileSync(
        "./_contracts_SimpleStorage_sol_SimpleStorage.abi",
        "utf8"
    );
    const binary = fs.readFileSync(
        "./_contracts_SimpleStorage_sol_SimpleStorage.bin",
        "utf8"
    );

    const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
    console.log("Deploying contract...");
    const contract = await contractFactory.deploy();
    await contract.deploymentTransaction()!.wait(1);
    const address = contract.getAddress();
    console.log(`Contract deployed at address: ${address}`);

    // const nonce = await wallet.getNonce();
    // const tx = {
    //     nonce: nonce,
    //     gasPrice: 20000000000,
    //     gasLimit: 1000000,
    //     to: null,
    //     value: 0,
    //     data: "0x" + binary,
    //     chainId: 1337,
    // };

    // const sentTxResponse = await wallet.sendTransaction(tx);
    // await sentTxResponse.wait(1);
    // console.log(sentTxResponse);

    //@ts-ignore
    const currentFavoriteNumber = await contract.retrieve();
    console.log(`Fav number: ${currentFavoriteNumber}`);
     //@ts-ignore
    const transactionResponse = await contract.store("8");
    const translationReceipt = await transactionResponse.wait(1);
     //@ts-ignore
    const updatedFavoriteNumber = await contract.retrieve();
    console.log(`Updated fav number: ${updatedFavoriteNumber}`);
};

main()
    .then(() => {
        process.exit(0);
    })
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });
