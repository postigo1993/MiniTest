pragma solidity ^0.4.25;

import "./Token.sol";
import "./Empresas.sol";
import "./Empleados.sol";
import "./Owned.sol";

contract PlataformaTokens is Empresas, Empleados, Token, Owned {

    /*
    * Eventos
    */
    event GeneradoraRegistrada(address _cuenta, string _nombre, string _cif);
    event DistribuidoraRegistrada(address _cuenta, string _nombre, string _cif, address _generadora);
    event ClienteRegistrado(address _cuenta, string _nombre, string _numCliente, address _distribuidora);
    event TokensEmitidos(address _from, address _to, uint256 _n);

    /*
    * Anadir una nueva generadora en el sistema
    */
    function registrarGeneradora(address _cuenta, string _nombre, string _cif) public onlyOwner {

        // Se anade a la tabla general de generadoras
        generadoras[_cuenta] = Generadora(_cuenta, _nombre, _cif, true);

        // se anade a la lista de direcciones de generadoras
        GeneraList.push(_cuenta);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistroG(_cuenta);

        emit GeneradoraRegistrada(generadoras[_cuenta].cuenta, generadoras[_cuenta].nombre, generadoras[_cuenta].cif);

    }

    /*
    * Anadir una nueva distribuidora en el sistema
    */
    function registrarDistribuidora(address _cuenta, string _nombre, string _cif, address _generadora) public onlyOwner {

        // Se anade a la tabla general de empresas
        distribuidoras[_cuenta] = Distribuidora(_cuenta, _nombre, _cif, _generadora, true);

        // se anade a la lista de direcciones de empresas
        DistriList.push(_cuenta);

        // se anade a la lista de direcciones de distribuidoras de las generadoras
        direccionesDistribuidoraGeneradora[msg.sender].push(_cuenta);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistroD(_cuenta);

        emit DistribuidoraRegistrada(distribuidoras[_cuenta].cuenta, distribuidoras[_cuenta].nombre, distribuidoras[_cuenta].cif);

    }

    /*
    * Una distribuidora puede invocar a esta funcion para anadir un nuevo cliente
    */
    function registrarCliente(address _cuenta, string _nombre, string _numCliente) public esDistriValida(msg.sender){

        // se anade a la tabla general de empleados
        clientes[_cuenta] = Cliente(_cuenta, _nombre, _numCliente, msg.sender, true);

        // se anade a la lista de direcciones de empleados de la empresa
        direccionesClientesDistribuidora[msg.sender].push(_cuenta);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistroC(_cuenta);

        emit ClienteRegistrado(_cuenta, _nombre, _numCliente, msg.sender);

    }

    /*
    * El administrador del sistema invoca a esta funcion para asignar los tokens iniciales a una generadora
    */
    function emitirTokensRegistroG(address _to) public esGeneValida(_to) onlyOwner {

        // se transfieren los tokens
        transfer(_to, 100);

        emit TokensEmitidos(msg.sender, _to, 100);
    }

    /*
    * El administrador del sistema invoca a esta funcion para asignar los tokens iniciales a una distribuidora
    */
    function emitirTokensRegistroD(address _to) public esDistriValida(_to) onlyOwner {

        // se transfieren los tokens
        transfer(_to, 100);

        emit TokensEmitidos(msg.sender, _to, 100);
    }

    /*
    * El administrador del sistema invoca a esta funcion para asignar los tokens iniciales a un cliente
    */
    function emitirTokensRegistroC(address _to) public esClienteValido(_to) onlyOwner {

        // se transfieren los tokens
        transfer(_to, 100);

        emit TokensEmitidos(msg.sender, _to, 100);
    }

    /*
    * Una cliente puede invocar a esta funcion para transferir tokens a otro cliente
    */
    function transferirTokensCC(address _to, uint256 _n) public esClienteValido(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }

    /*
    * Un cliente puede invocar a esta funcion para transferir tokens a una distribuidora
    */
    function transferirTokensCD(address _to, uint256 _n) public esClienteValido(msg.sender) esDistriValida(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }

    /*
    * Un cliente puede invocar a esta funcion para transferir tokens a una generadora
    */
    function transferirTokensCG(address _to, uint256 _n) public esClienteValido(msg.sender) esGeneValida(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }

    /*
    * Una distribuidora puede invocar a esta funcion para emitir tokens a un cliente
    */
    function emitirTokensDC(address _to, uint256 _n) public esDistriValida(msg.sender) ClienteEsDeLaDistribuidora(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }

    /*
    * Una distribuidora puede invocar a esta funcion para emitir tokens a una generadora con la que trabaje
    */
    function emitirTokensDG(address _to, uint256 _n) public esDistriValida(msg.sender) GeneradoraEsDeLaDistribuidora(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }

    /*
    * Una generadora puede invocar a esta funcion para emitir tokens a una distribuidora con la que trabaje
    */
    function emitirTokensGD(address _to, uint256 _n) public esGeneValida(msg.sender) DistribuidoraEsDeLaGeneradora(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }
