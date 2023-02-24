/// Module: testtokens
module testtokens::tokenb {
    use sui::coin::{Self, TreasuryCap};

    public struct TOKENB has drop {}

    fun init(witness: TOKENB, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<TOKENB>(witness, 9, b"TOKEN_B", b"TOKEN_B", b"", option::none(), ctx);
        // coin::mint_and_transfer<TOKENB>(&mut treasury_cap, 1000000000000000, tx_context::sender(ctx), ctx);

        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }
    
    public entry fun mint(
        treasury_cap: &mut TreasuryCap<TOKENB>, amount: u64, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer<TOKENB>(treasury_cap, amount, tx_context::sender(ctx), ctx)
    }
}
