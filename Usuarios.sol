
pragma solidity ^0.4.25;

contract Usuarios {

    struct Usuario {
      address DID;
      string distribuidora;
      uint32 saldoeuros;
      uint32 saldoGET;
      address distribuidora // para realizar comprobaciones de pertenencia a una distribuidora
      bool isValue;
    }

    // Para poder acceder rapidamente a la informacion de un usuario
    mapping(address => Usuario) usuarios;
    // Para obtener un listado por el que iterar con todas las direcciones de los usuarios existentes
    mapping(address => address[]) direccionesUsuarios;



    /*
    * Comprueba que el usuario pertenezca a la distribuidora que llama a la funcion (msg.sender)
    */
    modifier usuarioPerteneceDistribuidora (address _usuario){
        if(usuarios[_usuario].distribuidora == msg.sender){
            _;
        }
    }

    /*
    * Comprueba que el usuario es quien quiere acceder a su propia informacion
    */
    modifier tienePermisosPrivacidad (address _usuario){
        if(_usuario == msg.sender){
            _;
        }
    }

    /*
    * Comprueba que el saldo en euros del usuario es distinto de cero
    */
    modifier tieneSaldoEuros {
        if(usuarios[msg.sender].saldoeuros =! 0){
            _;
        }
    }

    /*
    * Comprueba que el saldo en GETs del usuario es distinto de cero
    */
    modifier tieneSaldoGETs {
        if(usuarios[msg.sender].saldoGET =! 0){
            _;
        }
    }

    /*
    * Comprueba que un usuario actualmente es cliente de la misma distribuidora que llama a la funcion (msg.sender)
    */
    modifier esCliente (address _to){
        if(usuarios[_to].distribuidora == usuarios[msg.sender].distribuidora){
            _;
        }
    }

    /*
    * Consultar la lista de usuarios de la distribuidora que llama
    */
    function listarUsuarios() public view returns(address[]){
        return direccionesUsuarios[msg.sender];
    }

    /*
    * Consultar el saldo de un usuario de la por el propio usuario
    */
    function getSaldoUsuario(address _DID) external view tienePermisosPrivacidad(_ID) returns(uint){
            return(usuarios[_DID].saldo);
    }

    /*
    * Comprobar si existe el usuario en el sistema a partir de una direccion valida
    */
    function existeUsuario(address _DID) public view returns (bool){
        return (usuarios[_DID].isValue);
    }
