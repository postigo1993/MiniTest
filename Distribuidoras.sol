pragma solidity ^0.4.25;

contract Distribuidoras {

    struct Distribuidora {
      address cuenta;
      string nombre;
      string cif;
      uint32 saldoeuros;
      uint32 saldoGET;
      bool isValue; // para comprobar que existe la distribuidora
    }

    // Para poder acceder rapidamente a la informacion de una distribuidora a partir de su direccion
    mapping(address => Distribuidora) distribuidoras;
    // Para obtener un listado por el que iterar con todas las direcciones de las distribuidoras existentes
    address[] DistriList;
    // Para obtener un listado por el que iterar con todas las direcciones de los clientes
    mapping(address => address[]) clientList;


    /*
    * Para comprobar que el msg.sender es una distribuidora existente en el sistema
    */
    modifier esDistriValida(address _cuenta){
        if(distribuidoras[_cuenta].isValue){
            _;
        }
    }

    /*
    * Para obtener una lista con todas las direcciones de distribuidoras en la que iterar
    */
    function listarDistri() public view returns (address[]) {
        return DistriList;
    }

    /*
    * Para obtener la informacion del nombre de una distribuidora a partir de su direccion
    */
    function getDistriNombre(address _cuenta) public view esDistriValida(_cuenta) returns (string){
        return (distribuidoras[_cuenta].nombre);
    }

    /*
    * Para obtener la informacion del cif de una distribuidora a partir de su direccion
    */
    function getDistriCIF(address _cuenta) public view esDistriValida(_cuenta) returns (string){
        return (distibuidoras[_cuenta].cif);
    }


     /*
    * Comprobar si existe una distribuidora en el sistema a partir de una direccion valida
    */
    function existeDistri(address _cuenta) public view returns (bool){
        return (distribuidoras[_cuenta].isValue);
    }

    /*
    * Comprueba que el saldo en euros de la distribuidora es distinto de cero
    */
    modifier tieneSaldoEuros {
        if(usuarios[msg.sender].saldoeuros =! 0){
            _;
        }
    }

    /*
    * Comprueba que el saldo en GETs dela distribuidora es distinto de cero
    */
    modifier tieneSaldoGETs {
        if(usuarios[msg.sender].saldoGET =! 0){
            _;
        }
    }
}
