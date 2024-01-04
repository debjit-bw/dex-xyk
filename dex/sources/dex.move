module dex::dex {
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Supply, Balance};
    public struct PoolToken<phantom X, phantom Y> has drop {}
    
    public struct LiquidityPool<phantom X, phantom Y> has key {
        id: UID,

        token_x: Balance<X>,
        token_y: Balance<Y>,
        pool_coin: Supply<PoolToken<X,Y>>,

        fee_bps: u64
    }

    #[allow(unused_function)]
    fun init(_: &mut TxContext) {}

    public fun sqrt(y: u64): u64 {
        if (y < 4) {
            if (y == 0) {
                0u64
            } else {
                1u64
            }
        } else {
            let mut z = y;
            let mut x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            };
            (z as u64)
        }
    }

    public fun create_pool<X, Y>(token_x: Balance<X>, token_y: Balance<Y>, fee_bps: u64, ctx: &mut TxContext): Coin<PoolToken<X,Y>> {

        // math for xyk
        let token_x_supply = balance::value(&token_x);
        let token_y_supply = balance::value(&token_y);
        let lp_to_mint = sqrt(token_x_supply) * sqrt(token_y_supply);

        // LP
        let mut lp_supply = balance::create_supply(PoolToken<X,Y> {});
        let lps = lp_supply.increase_supply(lp_to_mint);

        // create pool
        let pool = LiquidityPool<X,Y> {
            id: object::new(ctx),
            token_x: token_x,
            token_y: token_y,
            pool_coin: lp_supply,
            fee_bps: fee_bps,
            // fees_in_X: balance::zero<X>(),
            // fees_in_Y: balance::zero<Y>()
        };

        transfer::share_object(pool);

        coin::from_balance(lps, ctx)
    }

    public fun add_liquidity<X, Y>(pool: &mut LiquidityPool<X,Y>, token_x: Balance<X>, token_y: Balance<Y>, ctx: &mut TxContext): Coin<PoolToken<X,Y>> {
        let token_x_supply = balance::value(&token_x);
        let token_y_supply = balance::value(&token_y);

        let total_token_x_supply = balance::value(&pool.token_x) + token_x_supply;
        let total_token_y_supply = balance::value(&pool.token_y) + token_y_supply;
        let total_new_lp_supply = sqrt(total_token_x_supply) * sqrt(total_token_y_supply);

        let lps_to_mint = total_new_lp_supply - balance::supply_value(&pool.pool_coin);

        let _ = balance::join(&mut pool.token_x, token_x);
        let _ = balance::join(&mut pool.token_y, token_y);
        let lps = balance::increase_supply(&mut pool.pool_coin, lps_to_mint);
        coin::from_balance(lps, ctx)
    }

