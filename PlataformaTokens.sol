pragma solidity ^0.4.25;

import "./Token.sol";
import "./Empresas.sol";
import "./Empleados.sol";
import "./Owned.sol";

contract PlataformaTokens is Empresas, Empleados, Token, Owned{


    /*
    * Eventos
    */

    event GeneradoraRegistrada(address _cuenta, string _nombre, string _cif, uint32 _power)
    event DistribuidoraRegistrada(address _cuenta, string _nombre, string _cif);
    event UsuarioRegistrado(address _DID);
    event TokensEmitidos(address _from, address _to, uint256 _n);


    /*
    * Anadir una nueva distribuidora en el sistema
    */
    function registrarDistribuidora(address _cuenta, string _nombre, string _cif) public onlyOwner {

        // Se anade a la tabla general de empresas
        distribuidoras[_cuenta] = Distribuidora(_cuenta, _nombre, _cif, true);

        // se anade a la lista de direcciones de empresas
        DistriList.push(_cuenta);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistro(_cuenta);

        emit DistribuidoraRegistrada(distribuidoras[_cuenta].cuenta, distribuidoras[_cuenta].nombre, distribuidoras[_cuenta].cif);

    }

    /*
    * Anadir un nuevo usuario en el sistema
    */
    function registrarUsuario(address _DID) public onlyOwner {

        // Se anade a la tabla general de empresas
        usuarios[_DID] = Usuario(_DID, true);

        // se anade a la lista de direcciones de clientes
        clientList.push(_DID);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistro(_DID);

        emit UsuarioRegistrado(usuarios[_DID].DID);

    }

    /*
    * Anadir una nueva generadora renovables en el sistema
    */
    function registrarGeneRenov(address _cuenta, string _nombre, string _cif, uint32 _power) public onlyOwner {

        // Se anade a la tabla general de empresas
        generarenov[_cuenta] = GeneradoraRenov(_cuenta, _nombre, _cif, _power, true);

        // se anade a la lista de direcciones de empresas
        GenRenovList.push(_cuenta);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistro(_cuenta);

        emit GeneradoraRegistrada(generarenov[_cuenta].cuenta, generarenov[_cuenta].nombre, generarenov[_cuenta].cif, generarenov[_cuenta].power);

    }

    /*
    * Anadir una nueva generadora no renovable en el sistema
    */
    function registrarGeneNoRenov(address _cuenta, string _nombre, string _cif, uint32 _power, uint32 _CO2) public onlyOwner {

        // Se anade a la tabla general de empresas
        generanorenov[_cuenta] = GeneradoraNoRenov(_cuenta, _nombre, _cif, true);

        // se anade a la lista de direcciones de empresas
        GenNoRenovList.push(_cuenta);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistro(_cuenta);

        emit GeneradoraRegistrada(generanorenov[_cuenta].cuenta,generanorenov[_cuenta].nombre, generanorenov[_cuenta].cif, generanorenov[_cuenta].power, generanorenov[_cuenta].CO2);

    }

    /*
    * Una empresa puede invocar a esta funcion para anadir un nuevo empleado
    */
    function registrarUsuario(address _DID) public esDistriValida(msg.sender){

        // se anade a la tabla general de empleados
        usuarios[_cuenta] = Usuario(_DID, msg.sender, true);

        // se anade a la lista de direcciones de empleados de la empresa
        direccionesUsuarios[msg.sender].push(_cuenta);

        emit UsuarioRegistrado(_DID, msg.sender);

    }


    /*
    * El administrador del sistema invoca a esta funcion para asignar los tokens iniciales a una empresa
    */
    function emitirTokensRegistro(address _to) public esEmpresaValida(_to) onlyOwner {

        // se transfieren los tokens
        transfer(_to, 100);

        emit TokensEmitidos(msg.sender, _to, 100);
    }


    /*
    * Una empresa puede invocar a esta funcion para emitir tokens a un empleado
    */
    function emitirTokens(address _to, uint256 _n) public esEmpresaValida(msg.sender) empleadoTrabajaEnEstaEmpresa(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }


    /*
    * Una empleado puede invocar a esta funcion para transferir tokens a un companero de la misma empresa
    */
    function transferirTokens(address _to, uint256 _n) public esCompanero(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }


    /*
    * Una empleado puede invocar a esta funcion para canjear sus tokens por premios
    */
    function canjearTokens(uint256 _n) public{

        // encontramos la empresa a la que pertenece el empleado
        address empresa = empleados[msg.sender].empresa;

        // se transfieren los tokens a la empresa
        transfer(empresa, _n);

        emit TokensEmitidos(msg.sender, empresa, _n);
    }


}
