use starknet::ContractAddress;
#[starknet::interface]
trait IExample<TContractState>{
    fn iReceive(ref self : TContractState, requestSender : felt252, packet : Span<felt252>, srcChainId : felt252) -> u256;
    fn greeting(ref self: TContractState,Address: ContractAddress,reqsender: felt252,chainid : felt252,arr1 : Span<felt252>) -> u256;
    fn verifyCrossChainRequest(ref self : TContractState, requestIdentifier : u256, requestTimestamp : u256, requestSender : felt252, srcChainId: felt252, packet: Span<felt252>, handler : ContractAddress) -> bool;
    fn iAck(ref self: TContractState, requestIdentifier: u256, execFlags : bool, execData: u256);
    fn greeting1(self: @TContractState) -> Array<felt252>;
    fn getter(self: @TContractState) -> u256;
    fn handleVoyagerMessage(
        ref self: TContractState,
        tokenSent: ContractAddress,
        amount: u256,
        relayer: ContractAddress,
        message: Array<felt252>,
    );
}

// use starknet::ContractAddress;
// #[starknet::interface]
// trait IERC20<TContractState>{
//     fn iReceive(ref self : TContractState, requestSender : felt252, packet : Span<felt252>, srcChainId : felt252) -> starknet::SyscallResult<u256>;
// }



#[starknet::contract]
mod iReceive {
use traits::{Into, TryInto};
use starknet::ContractAddress;
use serde::Serde;
use array::ArrayTrait;
use array::SpanTrait;
use option::OptionTrait;
use starknet::{call_contract_syscall};
// use super::{IERC20,IERC20SafeDispatcherTrait,IERC20DispatcherTrait,IERC20SafeDispatcher};

    #[storage]
    struct Storage{
        value : u256,
    }

    #[external(v0)]
    impl exampleImpl of super::IExample<ContractState>{
        fn iReceive(ref self : ContractState, requestSender : felt252, packet : Span<felt252>, srcChainId : felt252) -> u256{

            2_u256
        }

        fn getter(self: @ContractState) -> u256{
            self.value.read()
        }

        fn greeting(ref self: ContractState,Address: ContractAddress,reqsender: felt252,chainid : felt252,arr1 : Span<felt252>) -> u256{
            let mut Input : Array<felt252> = ArrayTrait::new();
            // let mut arr1 : Array<felt252> = ArrayTrait::new();
            // arr1.append('Hello');
            // let reqsender : felt25c
            Serde::serialize(@reqsender,ref Input);
            Serde::serialize(@arr1, ref Input);
            Serde::serialize(@chainid, ref Input);
            let mut res = starknet::call_contract_syscall(
                    address: Address,
                    entry_point_selector: 0x005daf52fdbe5eb8b0f49ba6bfd6b2f34c55c6f539f4c2a3f36e9ea68e0738bd,
                    calldata: Input.span(),
                );

            let mut output = res.unwrap_syscall();

            let execData1 = Serde::<u256>::deserialize(ref output).unwrap();
            self.value.write(execData1);
            execData1
            
        }

        fn verifyCrossChainRequest(ref self : ContractState, requestIdentifier : u256, requestTimestamp : u256, requestSender : felt252, srcChainId: felt252, packet: Span<felt252>, handler : ContractAddress) -> bool{
            true
        }

        fn iAck(ref self: ContractState, requestIdentifier: u256, execFlags : bool, execData: u256){

        }
        fn handleVoyagerMessage(
        ref self: ContractState,
        tokenSent: ContractAddress,
        amount: u256,
        relayer: ContractAddress,
        message: Array<felt252>,
    ){}
        fn greeting1(self: @ContractState) -> Array<felt252>{
            let mut array3 : Array<felt252> = ArrayTrait::new();
            array3.append('Hello');
            array3.append('Yobro');

            let mut array2 : Array<felt252> = ArrayTrait::new();//packet
            array2.append('0x123');//felt252
            Serde::serialize(@array3,ref array2);//Array<felt252>
            array2.append(30);//felt252

            array2


        }
    }

    fn array_hashing(ref self: ContractState, array: Span<felt252>) -> felt252 {
            let mut array = array;
            let mut array_hash: felt252 = 0;
            
            loop {
                match array.pop_front() {
                    Option::Some(item) => {
                        array_hash = pedersen(array_hash, *item);
                    },
                    Option::None(_) => {
                        break array_hash;
                    }
                };
            }
        }

}
