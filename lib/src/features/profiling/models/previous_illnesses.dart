// To parse this JSON data, do
//
//     final previousIllnesses = previousIllnessesFromJson(jsonString);

import 'dart:convert';

PreviousIllnesses previousIllnessesFromJson(String str) => PreviousIllnesses.fromJson(json.decode(str));

String previousIllnessesToJson(PreviousIllnesses data) => json.encode(data.toJson());

class PreviousIllnesses {
    PreviousIllnesses({
        required this.asthma,
        required this.pneumonia,
        required this.chickenpox,
        required this.hepatitis,
        required this.heartProblems,
        required this.typhoidFever,
        required this.measles,
        required this.urinaryTractInfections,
        required this.seizuresConvulsions,
        required this.tuberculosis,
        required this.germanMeasles,
    });

    bool asthma;
    bool pneumonia;
    bool chickenpox;
    bool hepatitis;
    bool heartProblems;
    bool typhoidFever;
    bool measles;
    bool urinaryTractInfections;
    bool seizuresConvulsions;
    bool tuberculosis;
    bool germanMeasles;

    factory PreviousIllnesses.fromJson(Map<String, dynamic> json) => PreviousIllnesses(
        asthma: json["asthma"],
        pneumonia: json["pneumonia"],
        chickenpox: json["chickenpox"],
        hepatitis: json["hepatitis"],
        heartProblems: json["heartProblems"],
        typhoidFever: json["typhoidFever"],
        measles: json["measles"],
        urinaryTractInfections: json["urinaryTractInfections"],
        seizuresConvulsions: json["seizuresConvulsions"],
        tuberculosis: json["tuberculosis"],
        germanMeasles: json["germanMeasles"],
    );

    Map<String, dynamic> toJson() => {
        "asthma": asthma,
        "pneumonia": pneumonia,
        "chickenpox": chickenpox,
        "hepatitis": hepatitis,
        "heartProblems": heartProblems,
        "typhoidFever": typhoidFever,
        "measles": measles,
        "urinaryTractInfections": urinaryTractInfections,
        "seizuresConvulsions": seizuresConvulsions,
        "tuberculosis": tuberculosis,
        "germanMeasles": germanMeasles,
    };
}
