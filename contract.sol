pragma solidity >=0.4.22 <0.7.0;

contract my_money_ico {
    
    // nuhmero mahximo de my_money disponiveis no ICO
    uint public max_my_money = 100000;
    
    // taxa da cotacaho de my_money para o dolar
    uint public wei_to_my_money = 1000;
    
    // total de my_money comprado por investidores
    uint public total_my_money_bought;
    
    // equivalehncia dolar para my_money
    mapping( address => uint ) equity_my_money;
    
    // equivalehncia my_money to dolar 
    mapping( address => uint ) equity_wei;
    
        
    // inicia class
    constructor() public {
        total_my_money_bought = 0;
    }
    
    // verifica se naho estorou o max_my_money
    modifier can_buy( uint usd_invested ) {
        require ( usd_invested * wei_to_my_money + total_my_money_bought <= max_my_money );
        _;
    }
    
    // evento quando houver investimento
    event Invested( address investor, uint invested_value );
    
    // evento quando houver venda
    event Sell( address investor, uint sell_value );
    
    // retorna o valor de investimento em my_money
    function equity_in_my_money() external view returns ( uint ) {
        return equity_my_money[ msg.sender ];
    }
    
    
    // retorna o valor de investimento em dolares
    function equity_in_usd() external view returns ( uint ) {
        return equity_wei[ msg.sender ];
    }
    
    // compra my_money
    function buy_my_money() public payable can_buy( msg.value ) {
        uint my_money_bought = msg.value * wei_to_my_money;
        equity_my_money[ msg.sender ] += my_money_bought;
        equity_wei[ msg.sender ] += msg.value;
        total_my_money_bought += my_money_bought;
        emit Invested( msg.sender, msg.value );
    }
    
    // venda my_money
    function sell_my_money() public payable{
        uint my_money_sell = msg.value * wei_to_my_money;
        equity_my_money[ msg.sender ] -= my_money_sell;
        equity_wei[ msg.sender ] -= msg.value;
        total_my_money_bought -= my_money_sell;
        msg.sender.transfer( msg.value );
        emit Sell( msg.sender, msg.value );
    }
    
}
