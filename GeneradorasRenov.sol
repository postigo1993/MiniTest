pragma solidity ^0.4.25;

contract GeneradorasRenov {

    struct GeneradoraRenov {
      address cuenta;
      string nombre;
      string cif;
      uint32 saldoeuros;
      uint32 saldoGET;
      uint32 power; // potencia que genera la planta en W
      bool isValue; // para comprobar que existe la distribuidora
    }

    // Para poder acceder rapidamente a la informacion de una generadora a partir de su direccion
    mapping(address => GeneradoraRenov) generarenov;
    // Para obtener un listado por el que iterar con todas las direcciones de las generadoras renovables existentes
    address[] GenRenovList;


    /*
    * Para comprobar que el msg.sender es una generadora renovable existente en el sistema
    */
    modifier esGenRenovValida(address _cuenta){
        if(generarenov[_cuenta].isValue){
            _;
        }
    }

    /*
    * Para obtener una lista con todas las direcciones de generadoras renovables en la que iterar
    */
    function listarGenRenov() public view returns (address[]) {
        return GenRenovList;
    }

    /*
    * Para obtener la informacion del nombre de una generadora renovable a partir de su direccion
    */
    function getGenRenovNombre(address _cuenta) public view esGenRenovValida(_cuenta) returns (string){
        return (generarenov[_cuenta].nombre);
    }

    /*
    * Para obtener la informacion del cif de una generadora renovable a partir de su direccion
    */
    function getGenRenovCIF(address _cuenta) public view esGenRenovValida(_cuenta) returns (string){
        return (generarenov[_cuenta].cif);
    }

    /*
    * Para obtener la informacion de la potencia de una generadora renovable a partir de su direccion
    */
    function getGenRenovPower(address _cuenta) public view esGenRenovValida(_cuenta) returns (uint32){
        return (generarenov[_cuenta].power);
    }

     /*
    * Comprobar si existe una generadora renovable en el sistema a partir de una direccion valida
    */
    function existeGenRenov(address _cuenta) public view returns (bool){
        return (generarenov[_cuenta].isValue);
    }

    /*
    * Comprueba que el saldo en euros de la planta generadora es distinto de cero
    */
    modifier tieneSaldoEuros {
        if(usuarios[msg.sender].saldoeuros =! 0){
            _;
        }
    }

    /*
    * Comprueba que el saldo en GETs de la planta generadora es distinto de cero
    */
    modifier tieneSaldoGETs {
        if(usuarios[msg.sender].saldoGET =! 0){
            _;
        }
    }
}
