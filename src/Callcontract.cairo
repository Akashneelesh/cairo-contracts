
use starknet::SyscallResultTrait;
use starknet::ContractAddress;
#[starknet::interface]
trait IExample<TContractState>{
    // fn increase_Value(ref self: TContractState,value: u256,valfromStruct : Tryit1,val2 : Array<u256>,val3 : ValsetArgs,requestPayload : RequestPayload,val5: Array<u256>,val6: felt252) -> u256;
    fn increase_Value(ref self: TContractState,value : u256) -> u256;
    // fn increase_Value(ref self: TContractState,value: u256) -> u256;
    fn decrease_value(ref self: TContractState, value:u256,address1 : ContractAddress,entry_point_selector1 :felt252 ,calldata1: Span<felt252>) -> SyscallResult<Span<felt252>>;
}

#[starknet::contract]
mod Example {
use traits::{Into, TryInto};
use starknet::ContractAddress;
use serde::Serde;
use array::ArrayTrait;
use option::OptionTrait;
use starknet::{call_contract_syscall};
use starknet::SyscallResultTrait;

    #[storage]
    struct Storage{
        value : u256,
    }

// 0x14f78162221f9908311a8bab4980bf237ca2057c9e3b935f6f8e5d3d805431a
// fn selector 0x0396d07ba7e2e46e94457df90331d3d2b4ac485a42ec8e18a1755dee1cbc71e0
// calldata 

    #[external(v0)]
    impl examplesImpl of super::IExample<ContractState> {
        fn increase_Value(ref self: ContractState,value : u256) -> u256{
            self.value.write(self.value.read() + value);
            self.value.read()
        }

        fn decrease_value(ref self: ContractState, value:u256, address1 : ContractAddress,entry_point_selector1:felt252 ,calldata1: Span<felt252>) -> SyscallResult<Span<felt252>>{

            let res =  starknet::syscalls::call_contract_syscall(address : address1,
            entry_point_selector: entry_point_selector1, calldata :calldata1).unwrap_syscall();

            
        }

    }
}