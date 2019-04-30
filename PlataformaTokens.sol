pragma solidity ^0.4.25;

import "./Token.sol";
import "./Distribuidoras.sol";
import "./Usuarios.sol";
import "./GeneradorasRenov.sol";
import "./GeneradorasNoRenov.sol";
import "./Owned.sol";

contract PlataformaTokens is Usuarios, Distribuidoras, GeneradorasRenov, GeneradorasNoRenov, Token, Owned{


    /*
    * Eventos
    */

    event GeneradoraRegistrada(address _cuenta, string _nombre, string _cif, uint32 _power)
    event DistribuidoraRegistrada(address _cuenta, string _nombre, string _cif);
    event UsuarioRegistrado(address _DID);
    event TokensEmitidos(address _from, address _to, uint256 _n);


    /*
    * Anadir un nuevo usuario en el sistema
    */
    function registrarUsuario(address _DID) public onlyOwner {

        // Se anade a la tabla general de usuarios
        usuarios[_DID] = Usuario(_DID, true);

        // se anade a la lista de direcciones de clientes
        clientList.push(_DID);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistroU(_DID);

        emit UsuarioRegistrado(usuarios[_DID].DID);

    }

    /*
    * Anadir una nueva distribuidora en el sistema
    */
    function registrarDistribuidora(address _cuenta, string _nombre, string _cif) public onlyOwner {

        // Se anade a la tabla general de distribuidoras
        distribuidoras[_cuenta] = Distribuidora(_cuenta, _nombre, _cif, true);

        // se anade a la lista de direcciones de distribuidoras
        DistriList.push(_cuenta);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistroD(_cuenta);

        emit DistribuidoraRegistrada(distribuidoras[_cuenta].cuenta, distribuidoras[_cuenta].nombre, distribuidoras[_cuenta].cif);

    }


    /*
    * Anadir una nueva generadora renovable en el sistema
    */
    function registrarGeneRenov(address _cuenta, string _nombre, string _cif, uint32 _power) public onlyOwner {

        // Se anade a la tabla general de generadoras renovables
        generarenov[_cuenta] = GeneradoraRenov(_cuenta, _nombre, _cif, _power, true);

        // se anade a la lista de direcciones de generadoras renovables
        GenRenovList.push(_cuenta);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistroGR(_cuenta);

        emit GeneradoraRegistrada(generarenov[_cuenta].cuenta, generarenov[_cuenta].nombre, generarenov[_cuenta].cif, generarenov[_cuenta].power);

    }

    /*
    * Anadir una nueva generadora no renovable en el sistema
    */
    function registrarGeneNoRenov(address _cuenta, string _nombre, string _cif, uint32 _power, uint32 _CO2) public onlyOwner {

        // Se anade a la tabla general de generadoras no renovables
        generanorenov[_cuenta] = GeneradoraNoRenov(_cuenta, _nombre, _cif, true);

        // se anade a la lista de direcciones de generadoras no renovables
        GenNoRenovList.push(_cuenta);

        // se le transfieren una cantidad de tokens iniciales
        emitirTokensRegistroGNR(_cuenta);

        emit GeneradoraRegistrada(generanorenov[_cuenta].cuenta,generanorenov[_cuenta].nombre, generanorenov[_cuenta].cif, generanorenov[_cuenta].power, generanorenov[_cuenta].CO2);

    }

    /*
    * Una distribuidora puede invocar a esta funcion para anadir un nuevo usuario
    */
    function registrarUsuario(address _DID) public esDistriValida(msg.sender){

        // se anade a la tabla general de empleados
        usuarios[_cuenta] = Usuario(_DID, msg.sender, true);

        // se anade a la lista de direcciones de empleados de la empresa
        direccionesUsuarios[msg.sender].push(_cuenta);

        emit UsuarioRegistrado(_DID, msg.sender);

    }

    /*
    * El administrador del sistema invoca a esta funcion para asignar los tokens iniciales a un usuario
    */
    function emitirTokensRegistroU(address _to) public existeUsuario(_to) onlyOwner {

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
    * El administrador del sistema invoca a esta funcion para asignar los tokens iniciales a una generadora renovable
    */
    function emitirTokensRegistroGR(address _to) public esGenRenovValida(_to) onlyOwner {

        // se transfieren los tokens
        transfer(_to, 100);

        emit TokensEmitidos(msg.sender, _to, 100);
    }

    /*
    * El administrador del sistema invoca a esta funcion para asignar los tokens iniciales a una generadora no renovable
    */
    function emitirTokensRegistroGNR(address _to) public esGenNoRenovValida(_to) onlyOwner {

        // se transfieren los tokens
        transfer(_to, 100);

        emit TokensEmitidos(msg.sender, _to, 100);
    }

    /*
    * Un usuario puede invocar a esta funcion para transferir tokens a otro usuario del sistema
    */
    function transferirTokensUU(address _to, uint256 _n) public existeUsuario(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }

    /*
    * Una distribuidora puede invocar a esta funcion para emitir tokens a un cliente
    */
    function emitirTokensDU(address _to, uint256 _n) public esDistriValida(msg.sender) esCliente(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }

    /*
    * Un usuario puede invocar a esta funcion para transferir tokens a su distribuidora
    */
    function transferirTokensUD(address _to, uint256 _n) public existeUsuario(msg.sender) esCliente(_to){

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }

    /*
    * Un distribuidora puede invocar a esta funcion para transferir tokens a una generadora renovable
    */
    function transferirTokensDGR(address _to, uint256 _n) public esDistriValida(msg.sender) esGenRenovValida(_to) {

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }

    /*
    * Un distribuidora puede invocar a esta funcion para transferir tokens a una generadora no renovable
    */
    function transferirTokensDGNR(address _to, uint256 _n) public esDistriValida(msg.sender) esGenNoRenovValida(_to) {

        // se transfieren los tokens
        transfer(_to, _n);

        emit TokensEmitidos(msg.sender, _to, _n);
    }


}
