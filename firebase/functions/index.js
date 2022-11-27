const functions = require("firebase-functions");
const { evaluateCardsFast, rankDescription } = require('phe')


const admin = require("firebase-admin");
admin.initializeApp();

exports.checkCards = functions.https.onCall((data, context) => {

	//get table id
	const tableID = data.tableID
	const hands = data.hands;
	functions.logger.info(hands);

	var lowestRank = 9000000;
	var lowestId = "";
	for(let id in hands){
		functions.logger.info(id)
		functions.logger.info(hands[id])
		let rank = evaluateCardsFast(hands[id])
		if(rank < lowestRank){
			lowestId = id
			lowestRank = rank
		}
	}

	return { id: lowestId };

});

