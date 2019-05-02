pragma solidity ^0.4.25;

contract Distribuidoras {

    struct Distribuidora {
      address cuenta;
      string nombre;
      string cif;
      address generadora; // para realizar comprobaciones de pertenencia a una generadora
      bool isValue;
    }


    // Para poder acceder rapidamente a la informacion de una distribuidora (de cualquier generadora)
    mapping(address => Distribuidora) distribuidoras;
    // Cada generadora tiene una lista con las direcciones de sus distribuidoras
    mapping(address => address[]) direccionesDistribuidoraGeneradora;
    // Para obtener un listado por el que iterar con todas las direcciones de las distribuidoras existentes
    address[] DistriList;

    /*
    * Para comprobar que el msg.sender es una distribuidora existente en el sistema
    */
    modifier esDistriValida(address _cuenta){
        if(distribuidoras[_cuenta].isValue){
            _;
        }
    }

    /*
    * Comprueba que la distribuidora actualmente este trabajando para la empresa que llama a la funcion (msg.sender)
    */
    modifier DistribuidoraEsDeLaGeneradora (address _distribuidora){
        if(distribuidoras[_distribuidora].generadora == msg.sender){
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
    * Para obtener la informacion del cif de una empresa a partir de su direccion
    */
    function getDistriCIF(address _cuenta) public view esDistriValida(_cuenta) returns (string){
        return (distribuidoras[_cuenta].cif);
    }


     /*
    * Comprobar si existe una distribuidora en el sistema a partir de una direccion valida
    */
    function existeDistri(address _cuenta) public view returns (bool){
        return (distribuidoras[_cuenta].isValue);
    }

}
