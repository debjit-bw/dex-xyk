/// Module: testtokens
module testtokens::tokenc {
    use sui::coin::{Self, TreasuryCap};

    public struct TOKENC has drop {}

    fun init(witness: TOKENC, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<TOKENC>(witness, 9, b"TOKEN_C", b"TOKEN_C", b"", option::none(), ctx);
        // coin::mint_and_transfer<TOKENC>(&mut treasury_cap, 1000000000000000, tx_context::sender(ctx), ctx);

        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    public entry fun mint(
        treasury_cap: &mut TreasuryCap<TOKENC>, amount: u64, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer<TOKENC>(treasury_cap, amount, tx_context::sender(ctx), ctx)
    }
    
}
