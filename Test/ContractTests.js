// Pruebas unitarias "PlataformaTokens.sol"

const OperacionesToken = artifacts.require("OperacionesToken");

contract("ContractTests",async (accounts) => {

/* Por dotar de mayor comprension durante todos los tests:
accounts[0] es la cuenta administradora de la PlataformaTokens
accounts[1] es el Alberto, cliente de Iberdrola
accounts[2] es Maria, cliente de Endesa
accounts[3] es Iberdrola, socia de una planta solar
accounts[4] es Endesa, socia de una planta eólica
accounts[5] es la generadora solar
accounts[6] es la generadora eólica
*/

        it("Test0: La plataforma se ha desplegado correctamente y la cuenta administradora tiene el totalSupply de tokens", async () => {
          let plataforma = await OperacionesToken.deployed();
          let response = await plataforma.balanceOf.call(accounts[0], {from:accounts[0]});
          assert.equal(response, 100000);
        });

        it("Test1: Lista de distribuidoras en el sistema vacia al principio", async () => {
          let plataforma = await OperacionesToken.deployed();
      		let response = await plataforma.listarDistri.call();
      		assert.isEmpty(response);
        });

        it("Test2: Lista de generadoras en el sistema vacia al principio", async () => {
          let plataforma = await OperacionesToken.deployed();
      		let response = await plataforma.listarGene.call();
      		assert.isEmpty(response);
        });

        it("Test3: Se impide registrar una distribuidora desde una cuenta no administradora", async () => {
          let plataforma = await OperacionesToken.deployed();
          plataforma.registrarDistribuidora.call(accounts[3], "IBERDROLA", "CIF3","EOLICA MADRID" {from: accounts[8]})
          .then((response)=>{
            console.log(response);
          }, (error)=>{
            assert(error.message.indexOf('revert') >= 0, "Only Owner");
          });
        });

        it("Test4: Se impide registrar una generadora desde una cuenta no administradora", async () => {
          let plataforma = await OperacionesToken.deployed();
          plataforma.registrarGeneradora.call(accounts[5], "EOLICA MADRID", "ENDESA" "CIF5", {from: accounts[8]})
          .then((response)=>{
            console.log(response);
          }, (error)=>{
            assert(error.message.indexOf('revert') >= 0, "Only Owner");
          });
        });

        it("Test5: Registrar un cliente desde la cuenta administradora", async () => {
       		let plataforma = await OperacionesToken.deployed();
      	  await plataforma.registrarCliente.sendTransaction(accounts[1], "Alberto", "NUM1","ENDESA", {from: accounts[0]});
      		let nombre = await plataforma.getClienteNombre.call(accounts[1]);
          let numC = await plataforma.getClienteNum.call(accounts[1]);
          let distri = await plataforma.getClienteDistri.call(accounts[1]);
          // La plataforma debe haber asignado 100 GPIs a la empresa al registrarla
          let tokens = await plataforma.balanceOf.call(accounts[1], {from: accounts[1]});
      		assert.equal(nombre, "Alberto"); // nombre
      		assert.equal(numC, "NUM1");  // numeroCliente
          assert.equal(distri, "ENDESA");  // distribuidora
          assert.equal(tokens.valueOf(), 100); // saldo tokens
        });

        it("Test6: Registrar una distribuidora desde la cuenta administradora", async () => {
       		let plataforma = await OperacionesToken.deployed();
      	  await plataforma.registrarDistribuidora.sendTransaction(accounts[4], "ENDESA", "CIF4","EOLICA MADRID", {from: accounts[0]});
      		let nombre = await plataforma.getDistriNombre.call(accounts[4]);
          let cif = await plataforma.getDistriCIF.call(accounts[4]);
          let gener = await plataforma.getDistriGen.call(accounts[4]);
          // La plataforma debe haber asignado 100 GPIs a la empresa al registrarla
          let tokens = await plataforma.balanceOf.call(accounts[4], {from: accounts[4]});
      		assert.equal(nombre, "ENDESA"); // nombre
      		assert.equal(cif, "CIF4");  // cif
          assert.equal(gener, "EOLICA MADRID");  // generadora
          assert.equal(tokens.valueOf(), 100); // saldo tokens
        });

        it("Test6: Registrar una generadora desde la cuenta administradora", async () => {
       		let plataforma = await OperacionesToken.deployed();
      	  await plataforma.registrarGeneradora.sendTransaction(accounts[6], "EOLICA MADRID", "CIF6","ENDESA", {from: accounts[0]});
      		let nombre = await plataforma.getGeneNombre.call(accounts[6]);
          let cif = await plataforma.getGeneCIF.call(accounts[6]);
          let gener = await plataforma.getGeneDistri.call(accounts[6]);
          // La plataforma debe haber asignado 100 GPIs a la empresa al registrarla
          let tokens = await plataforma.balanceOf.call(accounts[6], {from: accounts[6]});
      		assert.equal(nombre, "EOLICA MADRID"); // nombre
      		assert.equal(cif, "CIF6");  // cif
          assert.equal(gener, "ENDESA");  // distribuidora
          assert.equal(tokens.valueOf(), 100); // saldo tokens
        });

        it("Test7: Se impide registrar un empleado desde una cuenta que no es de una empresa registrada en el sistema", async () => {
          let plataforma = await OperacionesToken.deployed();
          await plataforma.registrarCliente.sendTransaction(accounts[1], "Alberto", "Cliente1_Distribuidora1", {from: accounts[4]});
          let cliente = await plataforma.getDistriNombre.call(accounts[1], {from: accounts[4]});
          assert.isEmpty(cliente);
        });

        it("Test8: Se impide registrar un cliente desde la cuenta de otro cliente", async () => {
          let plataforma = await OperacionesToken.deployed();
          await plataforma.registrarCliente.sendTransaction(accounts[1], "Alberto", "Cliente1_Distri1", {from: accounts[3]});
          // Maria intenta crear una cuenta para Juan
          await plataforma.registrarCliente.sendTransaction(accounts[2], "Maria", "Cliente1_Distri2", {from: accounts[4]});
          let cliente = await plataforma.getClienteNombre.call(accounts[2], {from: accounts[3]});
          assert.isEmpty(cliente);
        });

        it("Test9: Registrar un empleado desde una cuenta de empresa valida y consultar su info desde esa misma empresa", async () => {
       		let plataforma = await OperacionesToken.deployed();
      		await plataforma.registrarCliente.sendTransaction(accounts[2], "Maria", "NUM2", {from: accounts[4]});
      		let nombre = await plataforma.getClienteNombre.call(accounts[2], {from: accounts[4]});
          let numero = await plataforma.getClienteNum.call(accounts[2], {from: accounts[4]});
      		assert.equal(nombre, "Maria"); // nombre
      		assert.equal(numero, "NUM2");  // numero empleado
        });

        it("Test10: Se impide consultar info de un cliente desde la cuenta de una empresa a la que no pertenece", async () => {
       		let plataforma = await OperacionesToken.deployed();
          await plataforma.registrarDistribuidora.sendTransaction(accounts[4], "ENDESA", "CIF2", "EOLICA MADRID" {from: accounts[0]});
          // ENDESA intenta acceder a la info de Alberto
      		let cliente = await plataforma.getClienteNombre.call(accounts[1], {from: accounts[4]});
      		assert.isEmpty(cliente);
        });

        it("Test11: Se impide consultar info de un cliente desde la cuenta de otro cliente", async () => {
          let plataforma = await OperacionesToken.deployed();
          await plataforma.registrarCliente.sendTransaction(accounts[2], "Maria", "Cliente1_Distribuidora2", {from: accounts[4]});
          // Maria intenta acceder a la info de Alberto
          let cliente = await plataforma.getClienteNombre.call(accounts[1], {from: accounts[2]});
          assert.isEmpty(cliente);
        });

        it("Test12: Se impide que una distribuidora emita tokens para un cliente que no es suyo", async () => {
          let plataforma = await OperacionesToken.deployed();
          let tokensEmpresa = await plataforma.balanceOf.call(accounts[3], {from: accounts[3]});
          assert.equal(tokensEmpresa.valueOf(), 100);
          // La otra empresa registra a un empleado
          await plataforma.registrarCliente.sendTransaction(accounts[2], "Maria", "Cliente1_Empresa2", {from: accounts[4]});
          let tokensEmpleado = await plataforma.balanceOf.call(accounts[2], {from: accounts[2]});
          assert.equal(tokensEmpleado.valueOf(), 0);
          // La empresa 1 no puede transferir tokens a empleados que no son suyos
          await plataforma.emitirTokens.sendTransaction(accounts[2], 1, {from: accounts[3]});
          tokensEmpleado = await plataforma.balanceOf.call(accounts[2], {from: accounts[2]});
          tokensEmpresa = await plataforma.balanceOf.call(accounts[3], {from: accounts[3]});
          assert.equal(tokensEmpleado.valueOf(), 0);
          assert.equal(tokensEmpresa.valueOf(), 100);
        });

        it("Test13: Una distribuidora emite tokens para un cliente suyo", async () => {
          let plataforma = await OperacionesToken.deployed();
          let tokensEmpresa = await plataforma.balanceOf.call(accounts[3], {from: accounts[3]});
          let tokensCliente = await plataforma.balanceOf.call(accounts[1], {from: accounts[1]});
          assert.equal(tokensEmpresa.valueOf(), 100);
          assert.equal(tokensCliente.valueOf(), 0);
          await plataforma.emitirTokens.sendTransaction(accounts[1], 10, {from: accounts[3]});
          tokensEmpresa = await plataforma.balanceOf.call(accounts[3], {from: accounts[3]});
          tokensCliente = await plataforma.balanceOf.call(accounts[1], {from: accounts[1]});
          assert.equal(tokensEmpresa.valueOf(), 90);
          assert.equal(tokensCliente.valueOf(), 10);
        });

        it("Test14: Un cliente transfiere tokens a otro cliente", async () => {
          let plataforma = await OperacionesToken.deployed();
          // Los empleados pueden transferirse tokens entre ellos
          let tokensCliente1 = await plataforma.balanceOf.call(accounts[1], {from: accounts[1]});
          let tokensCliente2 = await plataforma.balanceOf.call(accounts[2], {from: accounts[2]});
          assert.equal(tokensCliente1.valueOf(), 0);
          assert.equal(tokensCliente2.valueOf(), 10);
          await plataforma.transferirTokens.sendTransaction(accounts[1], 1, {from: accounts[2]});
          tokensCliente1 = await plataforma.balanceOf.call(accounts[1], {from: accounts[1]});
          tokensCliente2 = await plataforma.balanceOf.call(accounts[2], {from: accounts[2]});
          assert.equal(tokensCliente1.valueOf(), 1);
          assert.equal(tokensCliente2.valueOf(), 9);
        });

        it("Test15: Comprobar que existe un cliente en el sistema (TRUE)", async () => {
          let plataforma = await OperacionesToken.deployed();
          let response = await plataforma.existeCliente.call(accounts[2], {from: accounts[4]});
          assert.equal(response, true);
        });
