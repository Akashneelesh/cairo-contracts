#[starknet::interface]
use starknet::ContractAddress;
trait IHelloWorld<TContractState> {
    fn initialize(ref self: TContractState,gatewayAddress : ContractAddress, routeTokenAddress : ContractAddress);
    fn SetDappMetadata(ref self: TContractState, feePayerAddress: felt252);
    fn getRequestMetadata(self: @TContractState,gasLimit: u64, gasPrice: u64, ackGasLimit : u64, ackGasPrice: u64, relayerFees : u128, ackType: u8, isReadCall : bool, asmAddress: felt252) -> Array<felt252>;
    fn iSend(ref self: TContractState , routeAmount : u256, routeRecipient : felt252, destChainId : felt252, destContractAddress: felt252, ackType: u8,relayerFees : u128);
    fn iReceive(ref self: TContractState,srcContractAddress: felt252, ref packet : Span<felt252>, srcChainId : felt252) -> Array<felt252>;
    fn iAck(ref self : TContractState, eventIdentifier: u256, execFlag: bool,  ref execData : Span<felt252>);
}

#[starknet::contract]
mod HelloWorld {
    use starknet::ContractAddress;
    use starknet::{get_caller_address,get_contract_address};
    use array::{ArrayTrait,ArraySerde};
    use serde::Serde;
    // use core::array::serialize_array_helper;
    use core::array::SpanTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use router::interfaces::IGateway;
    // use router::interfaces::IGateway::{IGatewayDispatcher,IGatewayDispatcherTrait};
    use router::gatewayContract::{IGatewayContract,IGatewayContractDispatcher,IGatewayContractDispatcherTrait};
    use router::ERC20::erc20PresetMinterPauser::IERC20PresetMinter;
    use router::ERC20::erc20PresetMinterPauser::{IERC20PresetMinterDispatcher,IERC20PresetMinterDispatcherTrait};
    use starknet::event;

    const number : u256 = 20;

    // #[event]
    // #[derive(Drop, starknet::Event)]
    // struct Event{
    //     RequestFromRouterEvent: RequestFromRouterEvent,
    //     // CustomError : CustomError,
    // }

    // #[derive(Drop, starknet::Event)]
    // struct RequestFromRouterEvent{
    //     bridgeContract : felt252,
    //     data : u256,
    // }


    #[storage]
    struct Storage{
        owner: ContractAddress,
        gatewayContract : ContractAddress,
        greeting : felt252,
        lastEventIdentifier : u256,
        ackMessage : felt252,
        routeToken : ContractAddress,
        assetVault : ContractAddress,
    }

    // #[constructor]
    // fn constructor(ref self: ContractState,gatewayAddress : ContractAddress, routeTokenAddress : ContractAddress){
    //     self.owner.write(get_caller_address());
    //     self.gatewayContract.write(gatewayAddress);
    //     self.routeToken.write(routeTokenAddress);
    // }

    #[external(v0)]
    impl HelloWorld of super::IHelloWorld<ContractState> {
        fn initialize(ref self: ContractState,gatewayAddress : ContractAddress, routeTokenAddress : ContractAddress){
        self.owner.write(get_caller_address());
        self.gatewayContract.write(gatewayAddress);
        self.routeToken.write(routeTokenAddress);
    }
        fn SetDappMetadata(ref self: ContractState, feePayerAddress: felt252) {
            // assert(get_caller_address() == self.owner.read(),'Only owner');
            IGatewayContractDispatcher{contract_address : self.gatewayContract.read()}.SetDappMetadata(feePayerAddress);
            
        }
        fn getRequestMetadata(self: @ContractState,gasLimit: u64, gasPrice: u64, ackGasLimit : u64, ackGasPrice: u64, relayerFees : u128, ackType: u8, isReadCall : bool, asmAddress: felt252) -> Array<felt252>{
            self._getRequestMetadata(gasLimit,gasPrice,ackGasLimit,ackGasPrice,relayerFees,ackType,isReadCall,asmAddress)
        }

        fn iSend(ref self: ContractState , routeAmount : u256, routeRecipient : felt252, destChainId : felt252, destContractAddress: felt252, ackType: u8,relayerFees : u128){
            IERC20PresetMinterDispatcher{contract_address : self.routeToken.read()}.transfer_from(get_caller_address(),get_contract_address(),routeAmount);
            IERC20PresetMinterDispatcher{contract_address : self.routeToken.read()}.increase_allowance(get_contract_address(),routeAmount);
            
            let mut payload : Array<felt252> = ArrayTrait::new();
            let message : felt252 = 'Hello Router';
            Serde::serialize(@message,ref payload);
            // let len: felt252 = payload.len().into();
            // let value : felt252 = *payload.at(0);
            
            let requestMetadata : Array<felt252> = self._getRequestMetadata(1000000_u64,0_u64,1000000_u64,0_u64,relayerFees,ackType,false,'');

            let mut requestPacket: Array<felt252> = ArrayTrait::new();
            Serde::serialize(@destContractAddress,ref requestPacket);
            Serde::serialize(@payload.span(),ref requestPacket);

            let res = IGatewayContractDispatcher{contract_address : self.gatewayContract.read()}.iSend(1_u256,routeAmount,routeRecipient,destChainId,requestMetadata,requestPacket);
            self.lastEventIdentifier.write(res);
            


            // let serialized_payload: Array<felt252> = serialize_array_helper(payload.span(),ref requestPacket);
            // Serde::serialize(@payload,requestPacket);

        }
        fn iReceive(ref self: ContractState,srcContractAddress: felt252, ref packet : Span<felt252>, srcChainId : felt252) -> Array<felt252>{
            // assert(get_caller_address() == self.gatewayContract.read(),'Not the gatewayContract');
            let sampleStr : felt252 = Serde::deserialize(ref packet).unwrap();

            // if (keccak256(bytes(sampleStr)) == keccak256(bytes(""))) {
            // revert CustomError("String should not be empty");
            // }

            self.greeting.write(sampleStr);
            let mut res : Array<felt252> = ArrayTrait::new();
            Serde::serialize(@sampleStr,ref res);

            res

        }
        fn iAck(ref self : ContractState, eventIdentifier: u256, execFlag: bool, ref execData : Span<felt252>){
            let res : felt252 = Serde::deserialize(ref execData).unwrap();
            self.ackMessage.write(res);
        }


        
    }
    #[generate_trait]
    impl Helperfns of StorageTrait {
        fn _getRequestMetadata(self: @ContractState,gasLimit: u64, gasPrice: u64, ackGasLimit : u64, ackGasPrice: u64, relayerFees : u128, ackType: u8, isReadCall : bool, asmAddress: felt252) -> Array<felt252>{
            let gasLimit_felt252 : felt252 = gasLimit.into();
            let gasPrice_felt252 : felt252 = gasPrice.into();
            let ackgasLimit_felt252 : felt252 = ackGasLimit.into();
            let ackGasPrice_felt252 : felt252 = ackGasPrice.into();
            let relayerFees_felt252 : felt252 = relayerFees.into();
            let ackType_felt252 : felt252 = ackType.into();
            let isReadCall_felt252 = if(isReadCall){
                1
            } else {
                0
            };

            let mut encodedABI : Array<felt252> = ArrayTrait::new();
            Serde::serialize(@gasLimit_felt252,ref encodedABI);
            Serde::serialize(@gasPrice_felt252,ref encodedABI);
            Serde::serialize(@ackgasLimit_felt252,ref encodedABI);
            Serde::serialize(@ackGasPrice_felt252,ref encodedABI);
            Serde::serialize(@relayerFees_felt252,ref encodedABI);
            Serde::serialize(@ackType_felt252,ref encodedABI);
            Serde::serialize(@isReadCall_felt252,ref encodedABI);
            Serde::serialize(@asmAddress,ref encodedABI);

            encodedABI
        }

    }




}