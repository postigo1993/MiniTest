pragma solidity ^0.4.25;

contract Generadoras {

    struct Generadora {
      address cuenta;
      string nombre;
      address distribuidora;
      string cif;
      bool isValue;
    }


    // Para poder acceder rapidamente a la informacion de una distribuidora (de cualquier generadora)
    mapping(address => Generadora) generadoras;
    // Para obtener un listado por el que iterar con todas las direcciones de las distribuidoras existentes
    address[] GeneraList;

    /*
    * Para comprobar que el msg.sender es una generadora existente en el sistema
    */
    modifier esGeneValida(address _cuenta){
        if(generadoras[_cuenta].isValue){
            _;
        }
    }

    /*
    * Comprueba que la generadora actualmente es socia la distribuidora que llama a la funcion (msg.sender)
    */
    modifier GeneradoraEsDeLaDistribuidora (address _generadora){
        if(generadoras[_generadora].distribuidora == msg.sender){
            _;
        }
    }


    /*
    * Para obtener una lista con todas las direcciones de generadoras en la que iterar
    */
    function listarGene() public view returns (address[]) {
        return GeneraList;
    }


    /*
    * Para obtener la informacion del nombre de una generadora a partir de su direccion
    */
    function getGeneNombre(address _cuenta) public view esGeneValida(_cuenta) returns (string){
        return (generadoras[_cuenta].nombre);
    }


    /*
    * Para obtener la informacion del cif de una generadora a partir de su direccion
    */
    function getGeneCIF(address _cuenta) public view esGeneValida(_cuenta) returns (string){
        return (generadoras[_cuenta].cif);
    }

    /*
    * Para obtener la informacion de la distribuidora socia de una generadora a partir de su direccion
    */
    function getGeneDistri(address _cuenta) public view esGeneValida(_cuenta) returns (string){
        return (generadoras[_cuenta].distribuidora);
    }


     /*
    * Comprobar si existe una generadora en el sistema a partir de una direccion valida
    */
    function existeGene(address _cuenta) public view returns (bool){
        return (generadoras[_cuenta].isValue);
    }

}
