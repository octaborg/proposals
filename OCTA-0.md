Off Chain Transaction Analytics System Prototype
================================================

Table of Contents

-   [1. Abstract](#_abstract)
-   [2. Background](#_background)
-   [3. Use Cases/ Requirements](#_use_cases_requirements)
    -   [3.1. Expected Workflow](#_expected_workflow)
-   [4. Method](#_method)
    -   [4.1. Proposed Prototype System
        Overview](#_proposed_prototype_system_overview)
    -   [4.2. Interface: Loan Index Smart
        Contract](#_interface_loan_index_smart_contract)
    -   [4.3. Interface: Loan Smart Contract
        (LSC)](#_interface_loan_smart_contract_lsc)
    -   [4.4. Component: Transaction Data
        Repository](#_component_transaction_data_repository)
-   [5. Implementation](#_implementation)

## 1. Abstract

Off Chain Transaction Analytics(OCTA) system prototype is a proof of
concept system that provides an off-chain transaction analytics system
(OCTA for short) using Mina Snapps smart contracts. The motivation of it
is to provide a way for the users to protect their sensitive financial
data without exposing it to a third party while also gaining access to
critical financial services such as credit. Such a system, with the aid
of zk-SNARK technology, would allow one to prove one’s own financial
standing using their verified transaction history records without the
need of any centralized party’s approval. The prototype would provide a
basic protocol and a set of tools for all the actors: lenders, borrowers
and financial data repositories. We also aim to provide example
use-cases such as proving a borrower’s average income over a requested
period of time by a lender. Those examples would demonstrate how MINA
Snapps could affect daily interactions involving financial data
improving their security and privacy.

## 2. Background

A person’s financial transaction history is one of the most important
and private aspects of their lives. A party gaining access to this
information could in theory understand a person’s social/financial
standing, inter-personal relationships and even health. But some parts
of the present financial system is built on users readily handing over
this information in exchange for critical financial services or even
worse without them even knowing or benefiting from it. This leads to a
breach of privacy as well as possibly exposing this data to unintended
parties. Eg:

-   All non-collateralized lending systems require some form of
    transaction history analysis/verification to understand the
    borrower’s financial standing. Most common way to do achieve this at
    the moment is through a personal credit score that’s provided by a
    centralized entity that tracks the transactional habits. This has
    lead to [massive data
    breaches](https://en.wikipedia.org/wiki/2017_Equifax_data_breach) in
    the past.

-   Rewards systems such as credit card cashback schemes require access
    to a person’s transactions by third parties.

-   Mobile payment wallets such as Google Pay could mine a person’s
    transaction history data in order to provide a more personalized
    shopping experience.

Mina Snapps provide a way to preserve privacy while also giving access
to critical financial services to users by using off-chain verifiable
computation through the use of ZK Snarks. This document intends to
layout the possible use-cases, requirements and an architecture for a
prototype Off-Chain Transaction Analytics System based on Snapps.

## 3. Use Cases/ Requirements

Following are some simplified use cases for the prototype.

1.  As a lender I’m able to register in the system as being able to lend
    out a certain amount with a certain interest rate.

2.  As a borrower I want to be able to view lenders(potential loans)
    registered on the system.

3.  As a borrower I want to be able to request a loan from a lender
    registered on the system.

4.  As a lender I want to be able to request a potential borrower to
    prove their regular income to be more than a certain amount(referred
    to as the *Regular Income Proof*) using their bank transaction
    records.

5.  As a lender I want to be able to request a potential borrower to
    prove their average monthly balance to be more than a certain
    amount(Referred to as the *Average Monthly Balance Proof*) using
    their bank account balance and/or transactions.

6.  As a borrower I want to be able to provide a Regular Income Proof
    without exposing my bank transaction history to the lender.

7.  As a borrower I want to be able to provide an Average Monthly
    Balance Proof without exposing my bank transaction history to the
    lender.

8.  As a lender I want to be able to verify the source of a Regular
    Income Proof as coming from the borrower’s bank.

9.  As a lender I want to be able to verify the source of an Average
    Monthly Balance Proof as coming from the borrower’s bank.

10. As a lender I want to be able to verify a Regular Income Proof.

11. As a lender I want to be able to verify an Average Monthly Balance
    Proof.

12. As a lender I want to be able to approve and make a loan offer if
    the required transaction activity proofs are satisfied.

13. As a borrower I’m able to accept a loan offer if the conditions are
    agreeable, and receive the requested funds.

### 3.1. Expected Workflow

<img src="OCTA-0/highlevel-prototype.png" width="806" height="979" alt="highlevel prototype" />

## 4. Method

### 4.1. Proposed Prototype System Overview

<img src="OCTA-0/prototype-overview.png" width="543" height="803" alt="prototype overview" />

### 4.2. Interface: Loan Index Smart Contract

A simple smart contract that holds the account addresses of the
currently published loan smart contracts in the system. The use of this
is for the borrowers to be able to browse and see details of the
available loan contracts in the system.

TODO: Specify interface.

### 4.3. Interface: Loan Smart Contract (LSC)

The main smart contract for handling the business logic of the
lender-borrower interactions. The interface would look like the
following.

    // Loan smart contract interface
    class Loan extends SmartContract {
      @state(Field) interestRate: State<Field>;
      @state(Field) termInDays: State<Field>;

      // Terms of the loan are injected at construction
      constructor(
        loanAmount: UInt64,
        interestRate: Field;
        termInDays: Field;
        address: PublicKey,
        requiredProofs: RequiredProofs (1)
      ) {
        super(address);
        this.balance.addInPlace(loanAmount);
        this.interestRate = State.init(interestRate);
        this.termInDays = State.init(termInDays);
      }

      // Request a loan with required proofs
      @method async requestLoan(amount: UInt64, proofs: TransactionDataProofs) { (2)
        (3)
      }

      // Approve the loan for the given address
      @method async approve(address: PublicKey) {
      }

      // Accept the loan for the calling address
      @method async accept() {
      }

    }

1.  RequiredProofs data structure needs to be defined based on further
    research. Most probably an extension of CircuitValue class.

2.  TransactionDataProofs is a
    [proofSystem](https://github.com/o1-labs/snarkyjs/blob/2a8f64a764917d53fd5fa5e807d7159f89f47545/src/examples/wip.ts#L101)
    that need to be defined based on further research.

3.  Verify proofs. Then at the initial phase possibly disburse the loan.
    Later an approval method would be implemented together with support
    for accepting the loan by the borrower to disburse the loan.

#### 4.3.1. TransactionDataProofs

This is a new `proofSystem` for transaction statistics based on off
chain transaction data. It also needs to index the proofs it’s provided
to be able to be verified based on the `requireProofs` field of the LSC.

TODO R&D

### 4.4. Component: Transaction Data Repository

This is a separate service representing a transaction storage backend
for example of a bank. Proposed to be implemented as a nodejs
application.

#### 4.4.1. Component: HTTPS API

A REST API that received requests and provides signed transactions
data(stored in it’s database) in return. Signature scheme could follow
the same as [what is used by
Mina](https://github.com/MinaProtocol/mina/blob/develop/docs/specs/signatures/description.md).
Further details should be specified with research.

Endpoint

-   **HTTPS GET /api/transactions**

-   Format of output returned would follow,

        {
          "id": "id of the account",
          "balance": "latest available balance of the account",
          "timestamp": "timestamp when retrieved",
          "transactions": [
            {
              "id": "id of the transaction",
              "amount": "amount",
              "sendingAccount": {},
              "receivingAccount": {},
              "type": "type of the transaction",
              "description": "description",
              "timestamp": "date of the transaction"
            }
          ]

        }

#### 4.4.2. Component: Data Store

This is a mock database of transactions stored as a json file based on
the transaction format described above.

5. Implementation
-----------------

1.  TODO milestones etc. key results

Last updated 2022-01-22 22:03:02 +0100
