

function createHosp3 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p ../organizations/peerOrganizations/hosp3.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/hosp3.example.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-hosp3 --tls.certfiles ${PWD}/fabric-ca/hosp3/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-hosp3.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-hosp3.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-hosp3.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-hosp3.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/hosp3.example.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-hosp3 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/hosp3/tls-cert.pem
  { set +x; } 2>/dev/null

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-hosp3 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/hosp3/tls-cert.pem
  { set +x; } 2>/dev/null

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-hosp3 --id.name hosp3admin --id.secret hosp3adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/hosp3/tls-cert.pem
  { set +x; } 2>/dev/null

	mkdir -p ../organizations/peerOrganizations/hosp3.example.com/peers
  mkdir -p ../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-hosp3 -M ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/msp --csr.hosts peer0.hosp3.example.com --tls.certfiles ${PWD}/fabric-ca/hosp3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/hosp3.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-hosp3 -M ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/tls --enrollment.profile tls --csr.hosts peer0.hosp3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/hosp3/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/hosp3.example.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/hosp3.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/hosp3.example.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/hosp3.example.com/tlsca/tlsca.hosp3.example.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/hosp3.example.com/ca
  cp ${PWD}/../organizations/peerOrganizations/hosp3.example.com/peers/peer0.hosp3.example.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/hosp3.example.com/ca/ca.hosp3.example.com-cert.pem

  mkdir -p ../organizations/peerOrganizations/hosp3.example.com/users
  mkdir -p ../organizations/peerOrganizations/hosp3.example.com/users/User1@hosp3.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-hosp3 -M ${PWD}/../organizations/peerOrganizations/hosp3.example.com/users/User1@hosp3.example.com/msp --tls.certfiles ${PWD}/fabric-ca/hosp3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/hosp3.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/hosp3.example.com/users/User1@hosp3.example.com/msp/config.yaml

  mkdir -p ../organizations/peerOrganizations/hosp3.example.com/users/Admin@hosp3.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://hosp3admin:hosp3adminpw@localhost:11054 --caname ca-hosp3 -M ${PWD}/../organizations/peerOrganizations/hosp3.example.com/users/Admin@hosp3.example.com/msp --tls.certfiles ${PWD}/fabric-ca/hosp3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/hosp3.example.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/hosp3.example.com/users/Admin@hosp3.example.com/msp/config.yaml

}
