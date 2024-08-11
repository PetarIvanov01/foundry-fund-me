# Foundry FundMe Smart Contract

### Implemented the FundMe smart contract using Chainlink Oracles for ETH to USD price conversions. 

***The contract allows users to fund in ETH based on USD threshold using PriceConverter utilities.***

**Features include:**

- Owner-only withdrawal functions and safeguards against insufficient funding amounts. 
- Integrated error handling using custom errors for owner validation. 
- Enhanced contract reliability and security with immutable price feed and owner state variables.
- PriceConverter library facilitate ETH to USD conversions using Chainlink Oracles. 
    - Integrated with AggregatorV3Interface to ensure real-time and reliable price feeds.

### Scipts

- ***DeployFundMe.s.sol*** - Script using Forge standard library to deploy the FundMe contract. The script leverages HelperConfig to automatically select the appropriate network configuration, ensuring flexible deployments across different networks.

- Implemented two Foundry scripts, FundFundMe and WithdrawFundMe, to manage automated funding and balance withdrawal of the most recently deployed FundMe contract.

### Tests

Added comprehensive ***testing suite*** for the FundMe contract. The tests cover all critical functionalities such as: 
- funding
- owner withdrawals
- permissions
- fallback mechanisms
- tests for both individual and multiple funders

Implemented ***integration tests*** to verify user interaction scenarios. Tests ensure that users can fund and withdraw correctly through scripted interactions, validating the contract's behavior in realistic transaction sequences. Covers funding and withdrawal processes to confirm contract integrity and functionality.