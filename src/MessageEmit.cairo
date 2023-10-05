use core::array::ArrayTrait;
use starknet::ContractAddress;
#[starknet::interface]
trait IMessage<TContractState>{
    fn EmitSingleMessage(ref self : TContractState, name : felt252, age : u256, address: ContractAddress);
    fn EmitArrayMessage(ref self : TContractState, name : felt252, age : u256,name1 : felt252, age1 : u256, address: ContractAddress);
}

#[starknet::contract]
mod Message {
use traits::{Into, TryInto};
use starknet::ContractAddress;
use serde::Serde;
use array::ArrayTrait;
use array::SpanTrait;
use option::OptionTrait;
// use super::{Tryit1, ValsetArgs,RequestPayload};
use starknet::{eth_address,EthAddress};

    #[storage]
    struct Storage{
        value : u256,
    }

    #[derive(Drop, starknet::Event)]
    struct emitSingle {
        name : felt252,
        age : u256,
        address : ContractAddress
    }

    #[derive(Drop, starknet::Event)]
    struct emitArray {
        value : Span<felt252>, 
    }
    
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        emitSingle : emitSingle,
        emitArray : emitArray
    }



    #[external(v0)]
    impl examplesImpl of super::IMessage<ContractState> {
    fn EmitSingleMessage(ref self : ContractState, name : felt252, age : u256, address: ContractAddress){
        self.emit(Event::emitSingle(emitSingle{
            name : name,
            age : age,
            address : address,
        }));
    }
    fn EmitArrayMessage(ref self : ContractState, name : felt252, age : u256,name1 : felt252, age1 : u256, address: ContractAddress){
        let mut payload : Array<felt252> = ArrayTrait::new();
        name.serialize(ref payload);
        age.serialize(ref payload);
        name1.serialize(ref payload);
        age1.serialize(ref payload);
        address.serialize(ref payload);

        let mut payload2 : Array<felt252> = ArrayTrait::new();
        name.serialize(ref payload2);
        age.serialize(ref payload2);
        address.serialize(ref payload2);

        self.emit(Event::emitArray(emitArray{
            value : payload2.span()
        }));

        self.emit(Event::emitArray(emitArray{
            value : payload.span()
        }));
    }
}
}

