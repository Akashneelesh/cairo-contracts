
// use starknet::ContractAddress;
// use serde::Serde;
// use core::starknet::eth_address::EthAddress;
// use starknet::secp256k1::{Secp256k1Point, Secp256k1PointImpl};
// use starknet::secp256_trait::{
//         Secp256Trait, Secp256PointTrait, Signature, recover_public_key, secp256_ec_negate_scalar,
//         verify_eth_signature, is_signature_entry_valid
//     };
// #[starknet::interface]
// trait IExample<TContractState> {
//     fn check_pedersen( ref self: TContractState,value1 : u256) -> felt252;
//     fn read_value(self: @TContractState) -> felt252;
//     // fn check_keccak( ref self: ContractState,value1 : felt252, value2: u256, value3: EthAddress) -> u256;
// }

// #[starknet::contract]
// mod Greeting {
//         use starknet::ContractAddress;
//     // use router::utils::utils::Utils::{ValsetArgs};
//     use core::array::ArrayTrait;
//     use integer::{u128_byte_reverse, u256_from_felt252};
//     // use router::gatewayContract::gatewayContract;
//     use zeroable::IsZeroResult;
//     use core::starknet::eth_address::EthAddress;
//     use traits::{Into, TryInto};
//     use array::SpanTrait;
//     use option::OptionTrait;
//     use keccak::keccak_u256s_be_inputs;
//     use starknet::secp256_trait;
//     use starknet::secp256k1::{Secp256k1Point, Secp256k1PointImpl};
//     use starknet::secp256_trait::{
//         Secp256Trait, Secp256PointTrait, Signature, recover_public_key, secp256_ec_negate_scalar,
//         verify_eth_signature, is_signature_entry_valid,signature_from_vrs
//     };
//     use serde::Serde;
//     use hash::{pedersen, Pedersen, LegacyHash};
//     // use traits::{Into, TryInto};
//     use starknet::{eth_address::U256IntoEthAddress};
//     // use debug::PrintTrait;

//     #[storage]
//     struct Storage {
//         value: felt252,
//     }




//  #[external(v0)]
//     impl Greetings of super::IExample<ContractState> {

//     // fn check_keccak( ref self: ContractState,value1 : felt252, value2: u256, value3: EthAddress) -> u256{
//     //     fn check_pedersen( ref self: ContractState,value1 : u256) -> felt252{
//     //         let mut array1: Array<felt252> =  ArrayTrait::new();
//     //         Serde::serialize(@value1,ref array1);

//     //         let mut checkpoint = pedersen(0, *array1.at(0));
//     //         self.value.write(checkpoint);
//     //         checkpoint
       
//     // }

//     fn new_fn(){
//         let rrecepient : ContractAddress =contract_address_const::<0>();
//             let message : felt252 = 'Hello World';
//             let mut arr1 : Array<felt252> = ArrayTrait::new();
//             arr1.append(message);
//             let asmAddress1 : ContractAddress =contract_address_const::<0x03c12f1e651adbbb65ed4ea4a6524094ad6a8951740a6f6ed229d28462133ee2>();
//             let requestPayload : RequestPayload = RequestPayload{
//                 routeAmount : 0_u256,
//                 requestIdentifier : 0_u256,
//                 requestTimestamp : 10_u256,
//                 srcChainId : 1,
//                 routeRecipient : rrecepient,
//                 destChainId : 1,
//                 asmAddress : asmAddress1,
//                 requestSender : 0,
//                 handlerAddress : asmAddress1,
//                 packet : arr1.span(),
//                 isReadCall : false,

//             };
//     }

//     fn read_value(self: @ContractState) -> felt252 {
//         self.value.read()
//     }
    

       
   
// }

// }
