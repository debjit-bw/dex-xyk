/// Module: testtokens
module testtokens::tokena {
    use sui::coin::{Self, TreasuryCap};

    public struct TOKENA has drop {}

    fun init(witness: TOKENA, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<TOKENA>(witness, 9, b"TOKEN_A", b"TOKEN_A", b"", option::none(), ctx);
        // coin::mint_and_transfer<TOKENA>(&mut treasury_cap, 1000000000000000, tx_context::sender(ctx), ctx);

        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    public entry fun mint(
        treasury_cap: &mut TreasuryCap<TOKENA>, amount: u64, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer<TOKENA>(treasury_cap, amount, tx_context::sender(ctx), ctx)
    }
}
