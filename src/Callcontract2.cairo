// use serde::Serde;
use starknet::{eth_address, EthAddress};
#[derive(Copy, Drop, Serde)]
struct Bio {
    name: felt252,
    age: u256,
}
#[starknet::interface]
trait IExample<TContractState> {
    fn increase_value(ref self: TContractState) -> u256;
    fn increase_value2(ref self: TContractState, value: u256) -> u256;
    fn increase_value3(ref self: TContractState, value: u256) -> u256;
    fn increase_value4(ref self: TContractState, value: u256, value2: Bio) -> u256;
    fn increase_value5(ref self: TContractState, value: Array<u256>, value2: Bio);
    fn increase_Value6(
        ref self: TContractState, // value0: Array<EthAddress>,
        value01: Array<u64>,
        value02: u256,
        value1: Array<u256>,
    // value2: Array<u256>,
    // value3: Array<u64>
    );

    fn increase_value7(ref self: TContractState, value: Array<EthAddress>);

    fn increase_value_8(ref self: TContractState, value: EthAddress);
    fn increase_value_9(ref self: TContractState, value: Array<u256>);
    fn increase_value_10(ref self: TContractState, value: u256);
    fn increase_value_11(ref self: TContractState, value: felt252);
    fn get_value(self: @TContractState) -> u256;
    fn get_eth_Address(self: @TContractState) -> EthAddress;
}

#[starknet::contract]
mod Example {
    use traits::{Into, TryInto};
    use starknet::ContractAddress;
    use serde::Serde;
    use option::OptionTrait;
    use super::Bio;
    use starknet::{eth_address, EthAddress};

    #[storage]
    struct Storage {
        value: u256,
        value2: EthAddress,
    }


    #[external(v0)]
    impl examplesImpl of super::IExample<ContractState> {
        fn increase_value(ref self: ContractState) -> u256 {
            self.value.write(self.value.read() + 100_u256);
            self.value.read()
        }

        fn increase_value2(ref self: ContractState, value: u256) -> u256 {
            self.value.write(self.value.read() + value);
            self.value.read()
        }
        fn increase_value3(ref self: ContractState, value: u256) -> u256 {
            self.value.write(self.value.read() + value);
            self.value.read()
        }
        fn increase_value4(ref self: ContractState, value: u256, value2: Bio) -> u256 {
            // let sample: Bio = value2;
            // self.value2.write(sample);
            self.value.write(self.value.read() + value);
            self.value.read()
        }

        fn increase_value5(ref self: ContractState, value: Array<u256>, value2: Bio) {
            self.value.write(*value.at(0));
        }
        fn increase_Value6(
            ref self: ContractState, // value0: Array<EthAddress>,
            value01: Array<u64>,
            value02: u256,
            value1: Array<u256>,
        // value2: Array<u256>,
        // value3: Array<u64>
        ) {
            self.value.write(10000_u256);
        }

        fn increase_value7(ref self: ContractState, value: Array<EthAddress>) {
            self.value2.write(*value.at(0));
        }
        fn increase_value_8(ref self: ContractState, value: EthAddress) {
            self.value2.write(value);
        }
        fn increase_value_9(ref self: ContractState, value: Array<u256>) {
            let mut i = 0;
            loop {
                if (i >= value.len()) {
                    break;
                }

                let value: u256 = *value.at(i);
                let value_ethaddress: EthAddress = value.into();
                self.value2.write(value_ethaddress);
                i = i + 1;
            };
        }

        fn increase_value_8(ref self: ContractState, value: EthAddress) {
            self.value2.write(value);
        }

        fn increase_value_10(ref self: ContractState, value: u256) {
            let new_value: EthAddress = value.into();
            self.value2.write(new_value);
        }

        fn increase_value_11(ref self: ContractState, value: felt252) {
            let new_value: EthAddress = value.try_into().unwrap();
            self.value2.write(new_value);
        }

        fn get_value(self: @ContractState) -> u256 {
            self.value.read()
        }
        fn get_eth_Address(self: @ContractState) -> EthAddress {
            self.value2.read()
        }
    }
}
