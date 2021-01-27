/**
 * @author Jathin Sreenivas
 * @email jathin.sreenivas@stud.fra-uas.de
 * @create date 2021-01-27 12:44:37
 * @modify date 2021-01-27 16:07:06
 * @desc Paient specific methods - API documentation in http://localhost:3002/ swagger editor.
 */

// Bring common classes into scope, and Fabric SDK network class
const {capitalize, getMessage, validateRole} = require('../utils.js');
const network = require('../../patient-asset-transfer/application-javascript/app.js');


/**
 * @param  {Request} req Role in the header and patientId in the url
 * @param  {Response} res Body consists of json of the patient object
 * @description This method retrives an existing patient from the ledger
 */
exports.getPatientById = async (req, res) => {
  // User role from the request header is validated
  const userRole = req.headers.role;
  await validateRole('patient|doctor', userRole, res);
  const patientId = req.params.patientId;
  // Set up and connect to Fabric Gateway
  // TODO: Connect to network using patientID from req auth
  const networkObj = await network.connectToNetwork('hosp1admin');
  // Invoke the smart contract function
  const response = await network.invoke(networkObj, true, capitalize(userRole) + 'Contract:readPatient', patientId);
  (response.error) ? res.status(400).send(response.error) : res.status(200).send(JSON.parse(response));
};

/**
 * @param  {Request} req Body must be a json, role in the header and patientId in the url
 * @param  {Response} res A 200 response if patient is updated successfully else a 500 response with s simple message json
 * @description  This method updates an existing patient personal details. This method can be executed only by the patient.
 */
exports.updatePatientPersonalDetails = async (req, res) => {
  // User role from the request header is validated
  const userRole = req.headers.role;
  await validateRole('patient', userRole, res);
  // The request present in the body is converted into a single json string
  let args = req.body;
  args.patientId = req.params.patientId;
  args= [JSON.stringify(args)];
  // Set up and connect to Fabric Gateway
  // TODO: Connect to network using patientID from req auth
  const networkObj = await network.connectToNetwork('hosp1admin');
  // Invoke the smart contract function
  const response = await network.invoke(networkObj, false, capitalize(userRole) + 'Contract:updatePatientPersonalDetails', args);
  (response.error) ? res.status(500).send(response.error) : res.status(200).send(getMessage(false, 'Successfully Updated Patient.'));
};

/**
 * @param  {Request} req Role in the header and patientId in the url
 * @param  {Response} res Body consists of json of history of the patient object consists of time stamps and patient object
 * @description Retrives the history transaction of an asset(Patient) in the ledger
 */
exports.getPatientHistoryById = async (req, res) => {
  // User role from the request header is validated
  const userRole = req.headers.role;
  await validateRole('patient|doctor', userRole, res);
  const patientId = req.params.patientId;
  // Set up and connect to Fabric Gateway
  // TODO: Connect to network using patientID from req auth
  const networkObj = await network.connectToNetwork('hosp1admin');
  // Invoke the smart contract function
  const response = await network.invoke(networkObj, true, capitalize(userRole) + 'Contract:getPatientHistory', patientId);
  const parsedResponse = await JSON.parse(response);
  (response.error) ? res.status(400).send(response.error) : res.status(200).send(parsedResponse);
};
