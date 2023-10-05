// use core::array::ArrayTrait;
use core::result::ResultTrait;
use starknet::{eth_address,EthAddress,ContractAddress};
#[starknet::interface]
trait IL1L2<TContractState>{
    fn write_l1_bridge(ref self: TContractState, address : EthAddress) -> EthAddress;
    fn send_message(ref self: TContractState,l1_recipient : EthAddress,amount : u256, amount2 : u256);
    // fn handle_message(ref self : TContractState, from_address : felt252, account: ContractAddress, amount: u256, amount2: u256);
}

#[starknet::contract]
mod L1L2 {
use traits::{Into, TryInto};
use starknet::ContractAddress;
use serde::Serde;
use array::SpanTrait;
use array::ArrayTrait;
use option::OptionTrait;
use starknet::get_caller_address;
// use super::{Tryit1, ValsetArgs,RequestPayload};
use starknet::{eth_address,EthAddress};
use starknet::{ EthAddressIntoFelt252, EthAddressSerde,
        EthAddressZeroable, syscalls::send_message_to_l1_syscall, get_block_timestamp,
        replace_class_syscall
    };

    #[storage]
    struct Storage{
        l1_bridge : EthAddress,
        value1 : u256,
        value2 : u256,
    }
    #[derive(Drop, starknet::Event)]
    struct MessageSent {
        l1_recipient : EthAddress,
        amount : u256,
        amount2 : u256,
    }

    #[derive(Drop, starknet::Event)]
    struct MessageReceived {
        account : ContractAddress,
        amount : u256,
        amount2 : u256,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        MessageSent : MessageSent,
        MessageReceived : MessageReceived,
    }



    #[external(v0)]
    impl examplesImpl of super::IL1L2<ContractState> {
        fn write_l1_bridge(ref self: ContractState, address : EthAddress) -> EthAddress {
            self.l1_bridge.write(address);
            self.l1_bridge.read()
        }
        fn send_message(ref self: ContractState,l1_recipient : EthAddress,amount : u256, amount2 : u256){
            let caller_address = get_caller_address();
            let l1_bridge = self.l1_bridge.read();
            assert(amount != u256 {low : 0, high : 0}, 'Zero');

            let mut message_payload : Array<felt252> = ArrayTrait::new();
            l1_recipient.serialize(ref message_payload);
            amount.serialize(ref message_payload);
            amount2.serialize(ref message_payload);

            

            send_message_to_l1_syscall(to_address :l1_bridge.into(), payload : message_payload.span());

            self.emit(Event::MessageSent(MessageSent{
                l1_recipient : l1_recipient,
                amount : amount,
                amount2 : amount2,
            }))
       
        }

}

 #[l1_handler]
        fn handle_message(ref self : ContractState, from_address : felt252, account: ContractAddress, amount: u256, amount2: u256) {
            let l1_bridge = self.l1_bridge.read();

            assert(from_address == l1_bridge.into(),'expected from bridge only');
            self.value1.write(amount);
            self.value2.write(amount2);
            self.emit(Event::MessageReceived(MessageReceived{
                account : account,
                amount : amount,
                amount2 :amount2,
            }))
        }
    }


