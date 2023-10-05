// use starknet::ContractAddress;
// // use starknet::ContractAddress;
// use serde::Serde;
// use starknet::{eth_address,EthAddress};

// //  #[derive(Drop, Serde)]
// //     struct Tryit1{
// //         v1 : u256,
// //         v2 : u256,
// //         v3 : Span<ContractAddress>,
// //         v4 : Span<u64>,
// //         v5 : ContractAddress,
// //         v6 : Span<u256>,
// //         v7 : Span<felt252>,
// //     }

// // #[derive(Copy,Drop, Serde)]
// //     struct ValsetArgs {
// //         //Supposed to be array of addresses
// //         validators : Span<EthAddress>,
// //         powers : Span<u64>,
// //         valsetNonce : u256,
// //     }

// //      #[derive(Drop, Serde)]
// //     struct RequestPayload {
// //         routeAmount : u256,
// //         requestIdentifier : u256,
// //         requestTimestamp : u256,
// //         srcChainId : felt252,
// //         routeRecipient : ContractAddress,
// //         destChainId : felt252,
// //         asmAddress : ContractAddress,
// //         requestSender : felt252,
// //         handlerAddress : ContractAddress,
// //         packet : Span<felt252>,
// //         isReadCall: bool,
// //         // isReadCall : bool,
// //     }




// #[starknet::interface]
// trait IExample<TContractState>{
//     // fn increase_Value(ref self: TContractState,value: u256,valfromStruct : Tryit1,val2 : Array<u256>,val3 : ValsetArgs,requestPayload : RequestPayload,val5: Array<u256>,val6: felt252) -> u256;
//     fn increase_Value(ref self: TContractState);
//     // fn increase_Value(ref self: TContractState,value: u256) -> u256;
//     fn display_value(self: @TContractState) -> u256;
// }

// #[starknet::contract]
// mod Example {
// use traits::{Into, TryInto};
// use starknet::ContractAddress;
// use serde::Serde;
// use option::OptionTrait;
// // use super::{Tryit1, ValsetArgs,RequestPayload};
// use starknet::{eth_address,EthAddress};

//     #[storage]
//     struct Storage{
//         value : u256,
//     }


//     #[external(v0)]
//     impl examplesImpl of super::IExample<ContractState> {
//         fn increase_Value(ref self: ContractState){
//         // fn increase_Value(ref self: ContractState,val2 : Array<u256>,val3 : ValsetArgs,requestPayload : RequestPayload,val5: Array<u256>,val6: felt252) -> u256{
//         // fn increase_Value(ref self: ContractState,value: u256) -> u256{

//             // let routeRecipient_felt252 : felt252 = requestPayload.routeRecipient.into();
//             //     let asmAddress_felt252 : felt252 = requestPayload.asmAddress.into();
//             //     let val = requestPayload.requestIdentifier;
//             //     let handlerAddress_felt252 : felt252 = requestPayload.handlerAddress.into();
//             //     let routeAmount_felt252 : felt252 = requestPayload.routeAmount.try_into().unwrap();
//             //     let requestIdentifier_felt252: felt252 = requestPayload.requestIdentifier.try_into().unwrap();
//             //     let requestTimestamp_felt252 : felt252 = requestPayload.requestTimestamp.try_into().unwrap();
//             // // self.value.write(self.value.read() + value + valfromStruct.v1 + valfromStruct.v2);
//             // self.value.read()
//             self.value.write(100_u256);
//         }
//         fn display_value(self: @ContractState) -> u256{
//             self.value.read()
//         }

//     }
// }




// // mod test_example{
// //     use core::zeroable::Zeroable;
// // use starknet::syscalls::deploy_syscall;
// // use starknet::class_hash::Felt252TryIntoClassHash;
// // use starknet::contract_address::contract_address_const;
// // use starknet::ContractAddress;
// // use starknet::testing;
// // use traits::Into;
// // use traits::TryInto;
// // use option::OptionTrait;
// // use result::ResultTrait;
// // use array::ArrayTrait;
// // use debug::PrintTrait;
// // use super::{IExample,IExampleDispatcher,IExampleDispatcherTrait,Example};

// // fn setup() -> ContractAddress {
// //     let user1 = contract_address_const::<0x123456789>();

// //     let mut calldata : Array<felt252> = ArrayTrait::new();

// //     let (tokenAddress,_) = deploy_syscall(Example::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
// //     ).unwrap();

// //     tokenAddress   
// // }

// // #[test]
// // #[available_gas(200000000)]
// // fn test_increment() {
// //     let tokenAddress = setup();
// //     let amount : u256 = 100_u256;
// //     let token = IExampleDispatcher{contract_address : tokenAddress};
// //     let res = token.increase_Value(amount);
// //     assert(res == amount,'Invalid');
// // }

// // }

