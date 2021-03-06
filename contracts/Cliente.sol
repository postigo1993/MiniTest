pragma solidity ^0.4.25;

contract Cliente {

    struct Cliente {
      address cuenta;
      string nombre;
      string numCliente;
      address distribuidora; // para realizar comprobaciones de pertenencia a una distribuidora
      bool isValue;
    }


    // Para poder acceder rapidamente a la informacion de un cliente (de cualquier distribuidora)
    mapping(address => Cliente) clientes;
    // Cada distribuidora tiene una lista con las direcciones de sus clientes
    mapping(address => address[]) direccionesClientesDistribuidora;

    /*
    * Para comprobar que el msg.sender es un cliente existente en el sistema
    */
    modifier esClienteValido(address _cuenta){
        if(clientes[_cuenta].isValue){
            _;
        }
    }

    /*
    * Comprueba que el cliente actualmente tiene contratada la distribuidora que llama a la funcion (msg.sender)
    */
    modifier ClienteEsDeLaDistribuidora (address _cliente){
        if(clientes[_cliente].distribuidora == msg.sender){
            _;
        }
    }

    /*
    * Comprueba que el cliente es quien quiere acceder a su propia informacion o es su distribuidora
    */
    modifier tienePermisosPrivacidad (address _cliente){
        if(_cliente == msg.sender || clientes[_cliente].distribuidora == msg.sender){
            _;
        }
    }


    /*
    * Consultar el nombre de un cliente de la propia distribuidora
    */
    function getClienteNombre(address _cuenta) public view tienePermisosPrivacidad(_cuenta) returns(string){
            return(clientes[_cuenta].nombre);
    }

    /*
    * Consultar el numero de cliente de un cliente de la propia distribuidora
    */
    function getClienteNum(address _cuenta) public view tienePermisosPrivacidad(_cuenta) returns(string){
            return(clientes[_cuenta].numCliente);
    }

    /*
    *Consultar la distribuidora de un cliente de la propia distribuidoras
    */
    function getClienteDistri(address _cuenta) public view tienePermisosPrivacidad(_cuenta) returns(address){
           return(clientes[_cuenta].distribuidora);
    }

    /*
    * Consultar la lista de clientes de la distribuidora que llama
    */
    function listarClientes() public view returns(address[]){
        return direccionesClientesDistribuidora[msg.sender];
    }


    /*
    * Comprobar si existe el cliente en el sistema a partir de una direccion valida
    */
    function existeCliente(address _cuenta) public view returns (bool){
        return (clientes[_cuenta].isValue);
    }

}
