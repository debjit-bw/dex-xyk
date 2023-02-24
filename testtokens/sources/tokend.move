/// Module: testtokens
module testtokens::tokend {
    use sui::coin::{Self, TreasuryCap};

    public struct TOKEND has drop {}

    fun init(witness: TOKEND, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<TOKEND>(witness, 9, b"TOKEN_D", b"TOKEN_D", b"", option::none(), ctx);
        // coin::mint_and_transfer<TOKEND>(&mut treasury_cap, 1000000000000000, tx_context::sender(ctx), ctx);

        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    public entry fun mint(
        treasury_cap: &mut TreasuryCap<TOKEND>, amount: u64, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer<TOKEND>(treasury_cap, amount, tx_context::sender(ctx), ctx)
    }
}
