//  This file was automatically generated and should not be edited.

import Apollo

/// InterventionTypeEnum
public enum InterventionTypeEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case groundWork
  case implantation
  case fertilization
  case irrigation
  case care
  case cropProtection
  case harvest
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "GROUND_WORK": self = .groundWork
      case "IMPLANTATION": self = .implantation
      case "FERTILIZATION": self = .fertilization
      case "IRRIGATION": self = .irrigation
      case "CARE": self = .care
      case "CROP_PROTECTION": self = .cropProtection
      case "HARVEST": self = .harvest
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .groundWork: return "GROUND_WORK"
      case .implantation: return "IMPLANTATION"
      case .fertilization: return "FERTILIZATION"
      case .irrigation: return "IRRIGATION"
      case .care: return "CARE"
      case .cropProtection: return "CROP_PROTECTION"
      case .harvest: return "HARVEST"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: InterventionTypeEnum, rhs: InterventionTypeEnum) -> Bool {
    switch (lhs, rhs) {
      case (.groundWork, .groundWork): return true
      case (.implantation, .implantation): return true
      case (.fertilization, .fertilization): return true
      case (.irrigation, .irrigation): return true
      case (.care, .care): return true
      case (.cropProtection, .cropProtection): return true
      case (.harvest, .harvest): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// InterventionWaterVolumeUnit
public enum InterventionWaterVolumeUnitEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case cubicMeter
  case liter
  case hectoliter
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CUBIC_METER": self = .cubicMeter
      case "LITER": self = .liter
      case "HECTOLITER": self = .hectoliter
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .cubicMeter: return "CUBIC_METER"
      case .liter: return "LITER"
      case .hectoliter: return "HECTOLITER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: InterventionWaterVolumeUnitEnum, rhs: InterventionWaterVolumeUnitEnum) -> Bool {
    switch (lhs, rhs) {
      case (.cubicMeter, .cubicMeter): return true
      case (.liter, .liter): return true
      case (.hectoliter, .hectoliter): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// WeatherEnum
public enum WeatherEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case brokenClouds
  case clearSky
  case fewClouds
  case lightRain
  case mist
  case showerRain
  case snow
  case thunderstorm
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "BROKEN_CLOUDS": self = .brokenClouds
      case "CLEAR_SKY": self = .clearSky
      case "FEW_CLOUDS": self = .fewClouds
      case "LIGHT_RAIN": self = .lightRain
      case "MIST": self = .mist
      case "SHOWER_RAIN": self = .showerRain
      case "SNOW": self = .snow
      case "THUNDERSTORM": self = .thunderstorm
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .brokenClouds: return "BROKEN_CLOUDS"
      case .clearSky: return "CLEAR_SKY"
      case .fewClouds: return "FEW_CLOUDS"
      case .lightRain: return "LIGHT_RAIN"
      case .mist: return "MIST"
      case .showerRain: return "SHOWER_RAIN"
      case .snow: return "SNOW"
      case .thunderstorm: return "THUNDERSTORM"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: WeatherEnum, rhs: WeatherEnum) -> Bool {
    switch (lhs, rhs) {
      case (.brokenClouds, .brokenClouds): return true
      case (.clearSky, .clearSky): return true
      case (.fewClouds, .fewClouds): return true
      case (.lightRain, .lightRain): return true
      case (.mist, .mist): return true
      case (.showerRain, .showerRain): return true
      case (.snow, .snow): return true
      case (.thunderstorm, .thunderstorm): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// InterventionOutputType
public enum InterventionOutputTypeEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case straw
  case grain
  case silage
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "STRAW": self = .straw
      case "GRAIN": self = .grain
      case "SILAGE": self = .silage
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .straw: return "STRAW"
      case .grain: return "GRAIN"
      case .silage: return "SILAGE"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: InterventionOutputTypeEnum, rhs: InterventionOutputTypeEnum) -> Bool {
    switch (lhs, rhs) {
      case (.straw, .straw): return true
      case (.grain, .grain): return true
      case (.silage, .silage): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// InterventionOutputUnitEnum
public enum InterventionOutputUnitEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case quintalPerHectare
  case tonPerHectare
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "QUINTAL_PER_HECTARE": self = .quintalPerHectare
      case "TON_PER_HECTARE": self = .tonPerHectare
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .quintalPerHectare: return "QUINTAL_PER_HECTARE"
      case .tonPerHectare: return "TON_PER_HECTARE"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: InterventionOutputUnitEnum, rhs: InterventionOutputUnitEnum) -> Bool {
    switch (lhs, rhs) {
      case (.quintalPerHectare, .quintalPerHectare): return true
      case (.tonPerHectare, .tonPerHectare): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// HarvestLoadUnit
public enum HarvestLoadUnitEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case kilogram
  case quintal
  case ton
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "KILOGRAM": self = .kilogram
      case "QUINTAL": self = .quintal
      case "TON": self = .ton
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .kilogram: return "KILOGRAM"
      case .quintal: return "QUINTAL"
      case .ton: return "TON"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: HarvestLoadUnitEnum, rhs: HarvestLoadUnitEnum) -> Bool {
    switch (lhs, rhs) {
      case (.kilogram, .kilogram): return true
      case (.quintal, .quintal): return true
      case (.ton, .ton): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// Type of article
public enum ArticleTypeEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case seed
  case fertilizer
  case chemical
  case material
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "SEED": self = .seed
      case "FERTILIZER": self = .fertilizer
      case "CHEMICAL": self = .chemical
      case "MATERIAL": self = .material
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .seed: return "SEED"
      case .fertilizer: return "FERTILIZER"
      case .chemical: return "CHEMICAL"
      case .material: return "MATERIAL"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ArticleTypeEnum, rhs: ArticleTypeEnum) -> Bool {
    switch (lhs, rhs) {
      case (.seed, .seed): return true
      case (.fertilizer, .fertilizer): return true
      case (.chemical, .chemical): return true
      case (.material, .material): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// ArticleAllUnit
public enum ArticleAllUnitEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case unity
  case unityPerSquareMeter
  case unityPerHectare
  case thousand
  case thousandPerSquareMeter
  case thousandPerHectare
  case meter
  case gram
  case gramPerSquareMeter
  case gramPerHectare
  case kilogram
  case kilogramPerSquareMeter
  case kilogramPerHectare
  case quintal
  case quintalPerSquareMeter
  case quintalPerHectare
  case ton
  case tonPerSquareMeter
  case tonPerHectare
  case liter
  case literPerSquareMeter
  case literPerHectare
  case cubicMeter
  case cubicMeterPerSquareMeter
  case cubicMeterPerHectare
  case hectoliter
  case hectoliterPerSquareMeter
  case hectoliterPerHectare
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "UNITY": self = .unity
      case "UNITY_PER_SQUARE_METER": self = .unityPerSquareMeter
      case "UNITY_PER_HECTARE": self = .unityPerHectare
      case "THOUSAND": self = .thousand
      case "THOUSAND_PER_SQUARE_METER": self = .thousandPerSquareMeter
      case "THOUSAND_PER_HECTARE": self = .thousandPerHectare
      case "METER": self = .meter
      case "GRAM": self = .gram
      case "GRAM_PER_SQUARE_METER": self = .gramPerSquareMeter
      case "GRAM_PER_HECTARE": self = .gramPerHectare
      case "KILOGRAM": self = .kilogram
      case "KILOGRAM_PER_SQUARE_METER": self = .kilogramPerSquareMeter
      case "KILOGRAM_PER_HECTARE": self = .kilogramPerHectare
      case "QUINTAL": self = .quintal
      case "QUINTAL_PER_SQUARE_METER": self = .quintalPerSquareMeter
      case "QUINTAL_PER_HECTARE": self = .quintalPerHectare
      case "TON": self = .ton
      case "TON_PER_SQUARE_METER": self = .tonPerSquareMeter
      case "TON_PER_HECTARE": self = .tonPerHectare
      case "LITER": self = .liter
      case "LITER_PER_SQUARE_METER": self = .literPerSquareMeter
      case "LITER_PER_HECTARE": self = .literPerHectare
      case "CUBIC_METER": self = .cubicMeter
      case "CUBIC_METER_PER_SQUARE_METER": self = .cubicMeterPerSquareMeter
      case "CUBIC_METER_PER_HECTARE": self = .cubicMeterPerHectare
      case "HECTOLITER": self = .hectoliter
      case "HECTOLITER_PER_SQUARE_METER": self = .hectoliterPerSquareMeter
      case "HECTOLITER_PER_HECTARE": self = .hectoliterPerHectare
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .unity: return "UNITY"
      case .unityPerSquareMeter: return "UNITY_PER_SQUARE_METER"
      case .unityPerHectare: return "UNITY_PER_HECTARE"
      case .thousand: return "THOUSAND"
      case .thousandPerSquareMeter: return "THOUSAND_PER_SQUARE_METER"
      case .thousandPerHectare: return "THOUSAND_PER_HECTARE"
      case .meter: return "METER"
      case .gram: return "GRAM"
      case .gramPerSquareMeter: return "GRAM_PER_SQUARE_METER"
      case .gramPerHectare: return "GRAM_PER_HECTARE"
      case .kilogram: return "KILOGRAM"
      case .kilogramPerSquareMeter: return "KILOGRAM_PER_SQUARE_METER"
      case .kilogramPerHectare: return "KILOGRAM_PER_HECTARE"
      case .quintal: return "QUINTAL"
      case .quintalPerSquareMeter: return "QUINTAL_PER_SQUARE_METER"
      case .quintalPerHectare: return "QUINTAL_PER_HECTARE"
      case .ton: return "TON"
      case .tonPerSquareMeter: return "TON_PER_SQUARE_METER"
      case .tonPerHectare: return "TON_PER_HECTARE"
      case .liter: return "LITER"
      case .literPerSquareMeter: return "LITER_PER_SQUARE_METER"
      case .literPerHectare: return "LITER_PER_HECTARE"
      case .cubicMeter: return "CUBIC_METER"
      case .cubicMeterPerSquareMeter: return "CUBIC_METER_PER_SQUARE_METER"
      case .cubicMeterPerHectare: return "CUBIC_METER_PER_HECTARE"
      case .hectoliter: return "HECTOLITER"
      case .hectoliterPerSquareMeter: return "HECTOLITER_PER_SQUARE_METER"
      case .hectoliterPerHectare: return "HECTOLITER_PER_HECTARE"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ArticleAllUnitEnum, rhs: ArticleAllUnitEnum) -> Bool {
    switch (lhs, rhs) {
      case (.unity, .unity): return true
      case (.unityPerSquareMeter, .unityPerSquareMeter): return true
      case (.unityPerHectare, .unityPerHectare): return true
      case (.thousand, .thousand): return true
      case (.thousandPerSquareMeter, .thousandPerSquareMeter): return true
      case (.thousandPerHectare, .thousandPerHectare): return true
      case (.meter, .meter): return true
      case (.gram, .gram): return true
      case (.gramPerSquareMeter, .gramPerSquareMeter): return true
      case (.gramPerHectare, .gramPerHectare): return true
      case (.kilogram, .kilogram): return true
      case (.kilogramPerSquareMeter, .kilogramPerSquareMeter): return true
      case (.kilogramPerHectare, .kilogramPerHectare): return true
      case (.quintal, .quintal): return true
      case (.quintalPerSquareMeter, .quintalPerSquareMeter): return true
      case (.quintalPerHectare, .quintalPerHectare): return true
      case (.ton, .ton): return true
      case (.tonPerSquareMeter, .tonPerSquareMeter): return true
      case (.tonPerHectare, .tonPerHectare): return true
      case (.liter, .liter): return true
      case (.literPerSquareMeter, .literPerSquareMeter): return true
      case (.literPerHectare, .literPerHectare): return true
      case (.cubicMeter, .cubicMeter): return true
      case (.cubicMeterPerSquareMeter, .cubicMeterPerSquareMeter): return true
      case (.cubicMeterPerHectare, .cubicMeterPerHectare): return true
      case (.hectoliter, .hectoliter): return true
      case (.hectoliterPerSquareMeter, .hectoliterPerSquareMeter): return true
      case (.hectoliterPerHectare, .hectoliterPerHectare): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// Possible roles for an intervention doer
public enum OperatorRoleEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case `operator`
  case driver
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "OPERATOR": self = .operator
      case "DRIVER": self = .driver
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .operator: return "OPERATOR"
      case .driver: return "DRIVER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: OperatorRoleEnum, rhs: OperatorRoleEnum) -> Bool {
    switch (lhs, rhs) {
      case (.operator, .operator): return true
      case (.driver, .driver): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// Unit of article
public enum ArticleUnitEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case meter
  case unity
  case thousand
  case gram
  case kilogram
  case quintal
  case ton
  case liter
  case cubicMeter
  case hectoliter
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "METER": self = .meter
      case "UNITY": self = .unity
      case "THOUSAND": self = .thousand
      case "GRAM": self = .gram
      case "KILOGRAM": self = .kilogram
      case "QUINTAL": self = .quintal
      case "TON": self = .ton
      case "LITER": self = .liter
      case "CUBIC_METER": self = .cubicMeter
      case "HECTOLITER": self = .hectoliter
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .meter: return "METER"
      case .unity: return "UNITY"
      case .thousand: return "THOUSAND"
      case .gram: return "GRAM"
      case .kilogram: return "KILOGRAM"
      case .quintal: return "QUINTAL"
      case .ton: return "TON"
      case .liter: return "LITER"
      case .cubicMeter: return "CUBIC_METER"
      case .hectoliter: return "HECTOLITER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ArticleUnitEnum, rhs: ArticleUnitEnum) -> Bool {
    switch (lhs, rhs) {
      case (.meter, .meter): return true
      case (.unity, .unity): return true
      case (.thousand, .thousand): return true
      case (.gram, .gram): return true
      case (.kilogram, .kilogram): return true
      case (.quintal, .quintal): return true
      case (.ton, .ton): return true
      case (.liter, .liter): return true
      case (.cubicMeter, .cubicMeter): return true
      case (.hectoliter, .hectoliter): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// SpecieEnum
public enum SpecieEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case alliumAscalonicum
  case alliumCepa
  case alliumPorrum
  case alliumSativum
  case alliumSchoenoprasum
  case anethumGraveolens
  case apiumGraveolens
  case artemisiaDracunculus
  case avenaSativa
  case betaVulgaris
  case betaVulgarisCicla
  case brassicaNapusAnnua
  case brassicaNapusNapus
  case brassicaNapusRapifera
  case brassicaOleracea
  case brassicaOleraceaBotrytis
  case brassicaOleraceaCapitata
  case brassicaOleraceaItalica
  case brassicaRapaRapa
  case cannabisSativa
  case capsicum
  case capsicumAnnuum
  case chamaemelum
  case cicerArietinum
  case cichorium
  case cichoriumEndivia
  case citrullusLanatus
  case coriandrumSativum
  case cucumisMelo
  case cucumisSativus
  case cucumisSativusGherkin
  case cucurbitaMaxima
  case cucurbitaMaximaPotimarron
  case cucurbitaMoschata
  case cucurbitaMoschataButternut
  case cucurbitaPepo
  case cucurbitaPepoPepo
  case cynaraScolymus
  case dactylis
  case daucusCarota
  case erucaVesicaria
  case fagopyrumEsculentum
  case foeniculum
  case fragaria
  case glycineMax
  case helianthusAnnuus
  case helianthusTuberosus
  case hordeumDistichum
  case hordeumHexastichum
  case humulusLupulus
  case lactucaSativa
  case lensCulinaris
  case linumUsitatissimum
  case loliumPerenne
  case lotusCorniculatus
  case lupinus
  case medicagoSativa
  case melilotus
  case nicotianaTabacum
  case ocimumBasilicum
  case onobrychisViciifolia
  case oryzaSativa
  case pastinacaSativa
  case phaseolusVulgaris
  case pimpinellaAnisum
  case pisumSativum
  case plant
  case poaceae
  case raphanusSativus
  case secaleCereale
  case solanumLycopersicum
  case solanumMelongena
  case solanumTuberosum
  case sorghum
  case spinaciaOleracea
  case tragopogon
  case trifolium
  case triticosecale
  case triticumAestivum
  case triticumDurum
  case triticumSpelta
  case valerianellaLocusta
  case viciaFaba
  case viciaSativa
  case zeaMays
  case zeaMaysSaccharata
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ALLIUM_ASCALONICUM": self = .alliumAscalonicum
      case "ALLIUM_CEPA": self = .alliumCepa
      case "ALLIUM_PORRUM": self = .alliumPorrum
      case "ALLIUM_SATIVUM": self = .alliumSativum
      case "ALLIUM_SCHOENOPRASUM": self = .alliumSchoenoprasum
      case "ANETHUM_GRAVEOLENS": self = .anethumGraveolens
      case "APIUM_GRAVEOLENS": self = .apiumGraveolens
      case "ARTEMISIA_DRACUNCULUS": self = .artemisiaDracunculus
      case "AVENA_SATIVA": self = .avenaSativa
      case "BETA_VULGARIS": self = .betaVulgaris
      case "BETA_VULGARIS_CICLA": self = .betaVulgarisCicla
      case "BRASSICA_NAPUS_ANNUA": self = .brassicaNapusAnnua
      case "BRASSICA_NAPUS_NAPUS": self = .brassicaNapusNapus
      case "BRASSICA_NAPUS_RAPIFERA": self = .brassicaNapusRapifera
      case "BRASSICA_OLERACEA": self = .brassicaOleracea
      case "BRASSICA_OLERACEA_BOTRYTIS": self = .brassicaOleraceaBotrytis
      case "BRASSICA_OLERACEA_CAPITATA": self = .brassicaOleraceaCapitata
      case "BRASSICA_OLERACEA_ITALICA": self = .brassicaOleraceaItalica
      case "BRASSICA_RAPA_RAPA": self = .brassicaRapaRapa
      case "CANNABIS_SATIVA": self = .cannabisSativa
      case "CAPSICUM": self = .capsicum
      case "CAPSICUM_ANNUUM": self = .capsicumAnnuum
      case "CHAMAEMELUM": self = .chamaemelum
      case "CICER_ARIETINUM": self = .cicerArietinum
      case "CICHORIUM": self = .cichorium
      case "CICHORIUM_ENDIVIA": self = .cichoriumEndivia
      case "CITRULLUS_LANATUS": self = .citrullusLanatus
      case "CORIANDRUM_SATIVUM": self = .coriandrumSativum
      case "CUCUMIS_MELO": self = .cucumisMelo
      case "CUCUMIS_SATIVUS": self = .cucumisSativus
      case "CUCUMIS_SATIVUS_GHERKIN": self = .cucumisSativusGherkin
      case "CUCURBITA_MAXIMA": self = .cucurbitaMaxima
      case "CUCURBITA_MAXIMA_POTIMARRON": self = .cucurbitaMaximaPotimarron
      case "CUCURBITA_MOSCHATA": self = .cucurbitaMoschata
      case "CUCURBITA_MOSCHATA_BUTTERNUT": self = .cucurbitaMoschataButternut
      case "CUCURBITA_PEPO": self = .cucurbitaPepo
      case "CUCURBITA_PEPO_PEPO": self = .cucurbitaPepoPepo
      case "CYNARA_SCOLYMUS": self = .cynaraScolymus
      case "DACTYLIS": self = .dactylis
      case "DAUCUS_CAROTA": self = .daucusCarota
      case "ERUCA_VESICARIA": self = .erucaVesicaria
      case "FAGOPYRUM_ESCULENTUM": self = .fagopyrumEsculentum
      case "FOENICULUM": self = .foeniculum
      case "FRAGARIA": self = .fragaria
      case "GLYCINE_MAX": self = .glycineMax
      case "HELIANTHUS_ANNUUS": self = .helianthusAnnuus
      case "HELIANTHUS_TUBEROSUS": self = .helianthusTuberosus
      case "HORDEUM_DISTICHUM": self = .hordeumDistichum
      case "HORDEUM_HEXASTICHUM": self = .hordeumHexastichum
      case "HUMULUS_LUPULUS": self = .humulusLupulus
      case "LACTUCA_SATIVA": self = .lactucaSativa
      case "LENS_CULINARIS": self = .lensCulinaris
      case "LINUM_USITATISSIMUM": self = .linumUsitatissimum
      case "LOLIUM_PERENNE": self = .loliumPerenne
      case "LOTUS_CORNICULATUS": self = .lotusCorniculatus
      case "LUPINUS": self = .lupinus
      case "MEDICAGO_SATIVA": self = .medicagoSativa
      case "MELILOTUS": self = .melilotus
      case "NICOTIANA_TABACUM": self = .nicotianaTabacum
      case "OCIMUM_BASILICUM": self = .ocimumBasilicum
      case "ONOBRYCHIS_VICIIFOLIA": self = .onobrychisViciifolia
      case "ORYZA_SATIVA": self = .oryzaSativa
      case "PASTINACA_SATIVA": self = .pastinacaSativa
      case "PHASEOLUS_VULGARIS": self = .phaseolusVulgaris
      case "PIMPINELLA_ANISUM": self = .pimpinellaAnisum
      case "PISUM_SATIVUM": self = .pisumSativum
      case "PLANT": self = .plant
      case "POACEAE": self = .poaceae
      case "RAPHANUS_SATIVUS": self = .raphanusSativus
      case "SECALE_CEREALE": self = .secaleCereale
      case "SOLANUM_LYCOPERSICUM": self = .solanumLycopersicum
      case "SOLANUM_MELONGENA": self = .solanumMelongena
      case "SOLANUM_TUBEROSUM": self = .solanumTuberosum
      case "SORGHUM": self = .sorghum
      case "SPINACIA_OLERACEA": self = .spinaciaOleracea
      case "TRAGOPOGON": self = .tragopogon
      case "TRIFOLIUM": self = .trifolium
      case "TRITICOSECALE": self = .triticosecale
      case "TRITICUM_AESTIVUM": self = .triticumAestivum
      case "TRITICUM_DURUM": self = .triticumDurum
      case "TRITICUM_SPELTA": self = .triticumSpelta
      case "VALERIANELLA_LOCUSTA": self = .valerianellaLocusta
      case "VICIA_FABA": self = .viciaFaba
      case "VICIA_SATIVA": self = .viciaSativa
      case "ZEA_MAYS": self = .zeaMays
      case "ZEA_MAYS_SACCHARATA": self = .zeaMaysSaccharata
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .alliumAscalonicum: return "ALLIUM_ASCALONICUM"
      case .alliumCepa: return "ALLIUM_CEPA"
      case .alliumPorrum: return "ALLIUM_PORRUM"
      case .alliumSativum: return "ALLIUM_SATIVUM"
      case .alliumSchoenoprasum: return "ALLIUM_SCHOENOPRASUM"
      case .anethumGraveolens: return "ANETHUM_GRAVEOLENS"
      case .apiumGraveolens: return "APIUM_GRAVEOLENS"
      case .artemisiaDracunculus: return "ARTEMISIA_DRACUNCULUS"
      case .avenaSativa: return "AVENA_SATIVA"
      case .betaVulgaris: return "BETA_VULGARIS"
      case .betaVulgarisCicla: return "BETA_VULGARIS_CICLA"
      case .brassicaNapusAnnua: return "BRASSICA_NAPUS_ANNUA"
      case .brassicaNapusNapus: return "BRASSICA_NAPUS_NAPUS"
      case .brassicaNapusRapifera: return "BRASSICA_NAPUS_RAPIFERA"
      case .brassicaOleracea: return "BRASSICA_OLERACEA"
      case .brassicaOleraceaBotrytis: return "BRASSICA_OLERACEA_BOTRYTIS"
      case .brassicaOleraceaCapitata: return "BRASSICA_OLERACEA_CAPITATA"
      case .brassicaOleraceaItalica: return "BRASSICA_OLERACEA_ITALICA"
      case .brassicaRapaRapa: return "BRASSICA_RAPA_RAPA"
      case .cannabisSativa: return "CANNABIS_SATIVA"
      case .capsicum: return "CAPSICUM"
      case .capsicumAnnuum: return "CAPSICUM_ANNUUM"
      case .chamaemelum: return "CHAMAEMELUM"
      case .cicerArietinum: return "CICER_ARIETINUM"
      case .cichorium: return "CICHORIUM"
      case .cichoriumEndivia: return "CICHORIUM_ENDIVIA"
      case .citrullusLanatus: return "CITRULLUS_LANATUS"
      case .coriandrumSativum: return "CORIANDRUM_SATIVUM"
      case .cucumisMelo: return "CUCUMIS_MELO"
      case .cucumisSativus: return "CUCUMIS_SATIVUS"
      case .cucumisSativusGherkin: return "CUCUMIS_SATIVUS_GHERKIN"
      case .cucurbitaMaxima: return "CUCURBITA_MAXIMA"
      case .cucurbitaMaximaPotimarron: return "CUCURBITA_MAXIMA_POTIMARRON"
      case .cucurbitaMoschata: return "CUCURBITA_MOSCHATA"
      case .cucurbitaMoschataButternut: return "CUCURBITA_MOSCHATA_BUTTERNUT"
      case .cucurbitaPepo: return "CUCURBITA_PEPO"
      case .cucurbitaPepoPepo: return "CUCURBITA_PEPO_PEPO"
      case .cynaraScolymus: return "CYNARA_SCOLYMUS"
      case .dactylis: return "DACTYLIS"
      case .daucusCarota: return "DAUCUS_CAROTA"
      case .erucaVesicaria: return "ERUCA_VESICARIA"
      case .fagopyrumEsculentum: return "FAGOPYRUM_ESCULENTUM"
      case .foeniculum: return "FOENICULUM"
      case .fragaria: return "FRAGARIA"
      case .glycineMax: return "GLYCINE_MAX"
      case .helianthusAnnuus: return "HELIANTHUS_ANNUUS"
      case .helianthusTuberosus: return "HELIANTHUS_TUBEROSUS"
      case .hordeumDistichum: return "HORDEUM_DISTICHUM"
      case .hordeumHexastichum: return "HORDEUM_HEXASTICHUM"
      case .humulusLupulus: return "HUMULUS_LUPULUS"
      case .lactucaSativa: return "LACTUCA_SATIVA"
      case .lensCulinaris: return "LENS_CULINARIS"
      case .linumUsitatissimum: return "LINUM_USITATISSIMUM"
      case .loliumPerenne: return "LOLIUM_PERENNE"
      case .lotusCorniculatus: return "LOTUS_CORNICULATUS"
      case .lupinus: return "LUPINUS"
      case .medicagoSativa: return "MEDICAGO_SATIVA"
      case .melilotus: return "MELILOTUS"
      case .nicotianaTabacum: return "NICOTIANA_TABACUM"
      case .ocimumBasilicum: return "OCIMUM_BASILICUM"
      case .onobrychisViciifolia: return "ONOBRYCHIS_VICIIFOLIA"
      case .oryzaSativa: return "ORYZA_SATIVA"
      case .pastinacaSativa: return "PASTINACA_SATIVA"
      case .phaseolusVulgaris: return "PHASEOLUS_VULGARIS"
      case .pimpinellaAnisum: return "PIMPINELLA_ANISUM"
      case .pisumSativum: return "PISUM_SATIVUM"
      case .plant: return "PLANT"
      case .poaceae: return "POACEAE"
      case .raphanusSativus: return "RAPHANUS_SATIVUS"
      case .secaleCereale: return "SECALE_CEREALE"
      case .solanumLycopersicum: return "SOLANUM_LYCOPERSICUM"
      case .solanumMelongena: return "SOLANUM_MELONGENA"
      case .solanumTuberosum: return "SOLANUM_TUBEROSUM"
      case .sorghum: return "SORGHUM"
      case .spinaciaOleracea: return "SPINACIA_OLERACEA"
      case .tragopogon: return "TRAGOPOGON"
      case .trifolium: return "TRIFOLIUM"
      case .triticosecale: return "TRITICOSECALE"
      case .triticumAestivum: return "TRITICUM_AESTIVUM"
      case .triticumDurum: return "TRITICUM_DURUM"
      case .triticumSpelta: return "TRITICUM_SPELTA"
      case .valerianellaLocusta: return "VALERIANELLA_LOCUSTA"
      case .viciaFaba: return "VICIA_FABA"
      case .viciaSativa: return "VICIA_SATIVA"
      case .zeaMays: return "ZEA_MAYS"
      case .zeaMaysSaccharata: return "ZEA_MAYS_SACCHARATA"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: SpecieEnum, rhs: SpecieEnum) -> Bool {
    switch (lhs, rhs) {
      case (.alliumAscalonicum, .alliumAscalonicum): return true
      case (.alliumCepa, .alliumCepa): return true
      case (.alliumPorrum, .alliumPorrum): return true
      case (.alliumSativum, .alliumSativum): return true
      case (.alliumSchoenoprasum, .alliumSchoenoprasum): return true
      case (.anethumGraveolens, .anethumGraveolens): return true
      case (.apiumGraveolens, .apiumGraveolens): return true
      case (.artemisiaDracunculus, .artemisiaDracunculus): return true
      case (.avenaSativa, .avenaSativa): return true
      case (.betaVulgaris, .betaVulgaris): return true
      case (.betaVulgarisCicla, .betaVulgarisCicla): return true
      case (.brassicaNapusAnnua, .brassicaNapusAnnua): return true
      case (.brassicaNapusNapus, .brassicaNapusNapus): return true
      case (.brassicaNapusRapifera, .brassicaNapusRapifera): return true
      case (.brassicaOleracea, .brassicaOleracea): return true
      case (.brassicaOleraceaBotrytis, .brassicaOleraceaBotrytis): return true
      case (.brassicaOleraceaCapitata, .brassicaOleraceaCapitata): return true
      case (.brassicaOleraceaItalica, .brassicaOleraceaItalica): return true
      case (.brassicaRapaRapa, .brassicaRapaRapa): return true
      case (.cannabisSativa, .cannabisSativa): return true
      case (.capsicum, .capsicum): return true
      case (.capsicumAnnuum, .capsicumAnnuum): return true
      case (.chamaemelum, .chamaemelum): return true
      case (.cicerArietinum, .cicerArietinum): return true
      case (.cichorium, .cichorium): return true
      case (.cichoriumEndivia, .cichoriumEndivia): return true
      case (.citrullusLanatus, .citrullusLanatus): return true
      case (.coriandrumSativum, .coriandrumSativum): return true
      case (.cucumisMelo, .cucumisMelo): return true
      case (.cucumisSativus, .cucumisSativus): return true
      case (.cucumisSativusGherkin, .cucumisSativusGherkin): return true
      case (.cucurbitaMaxima, .cucurbitaMaxima): return true
      case (.cucurbitaMaximaPotimarron, .cucurbitaMaximaPotimarron): return true
      case (.cucurbitaMoschata, .cucurbitaMoschata): return true
      case (.cucurbitaMoschataButternut, .cucurbitaMoschataButternut): return true
      case (.cucurbitaPepo, .cucurbitaPepo): return true
      case (.cucurbitaPepoPepo, .cucurbitaPepoPepo): return true
      case (.cynaraScolymus, .cynaraScolymus): return true
      case (.dactylis, .dactylis): return true
      case (.daucusCarota, .daucusCarota): return true
      case (.erucaVesicaria, .erucaVesicaria): return true
      case (.fagopyrumEsculentum, .fagopyrumEsculentum): return true
      case (.foeniculum, .foeniculum): return true
      case (.fragaria, .fragaria): return true
      case (.glycineMax, .glycineMax): return true
      case (.helianthusAnnuus, .helianthusAnnuus): return true
      case (.helianthusTuberosus, .helianthusTuberosus): return true
      case (.hordeumDistichum, .hordeumDistichum): return true
      case (.hordeumHexastichum, .hordeumHexastichum): return true
      case (.humulusLupulus, .humulusLupulus): return true
      case (.lactucaSativa, .lactucaSativa): return true
      case (.lensCulinaris, .lensCulinaris): return true
      case (.linumUsitatissimum, .linumUsitatissimum): return true
      case (.loliumPerenne, .loliumPerenne): return true
      case (.lotusCorniculatus, .lotusCorniculatus): return true
      case (.lupinus, .lupinus): return true
      case (.medicagoSativa, .medicagoSativa): return true
      case (.melilotus, .melilotus): return true
      case (.nicotianaTabacum, .nicotianaTabacum): return true
      case (.ocimumBasilicum, .ocimumBasilicum): return true
      case (.onobrychisViciifolia, .onobrychisViciifolia): return true
      case (.oryzaSativa, .oryzaSativa): return true
      case (.pastinacaSativa, .pastinacaSativa): return true
      case (.phaseolusVulgaris, .phaseolusVulgaris): return true
      case (.pimpinellaAnisum, .pimpinellaAnisum): return true
      case (.pisumSativum, .pisumSativum): return true
      case (.plant, .plant): return true
      case (.poaceae, .poaceae): return true
      case (.raphanusSativus, .raphanusSativus): return true
      case (.secaleCereale, .secaleCereale): return true
      case (.solanumLycopersicum, .solanumLycopersicum): return true
      case (.solanumMelongena, .solanumMelongena): return true
      case (.solanumTuberosum, .solanumTuberosum): return true
      case (.sorghum, .sorghum): return true
      case (.spinaciaOleracea, .spinaciaOleracea): return true
      case (.tragopogon, .tragopogon): return true
      case (.trifolium, .trifolium): return true
      case (.triticosecale, .triticosecale): return true
      case (.triticumAestivum, .triticumAestivum): return true
      case (.triticumDurum, .triticumDurum): return true
      case (.triticumSpelta, .triticumSpelta): return true
      case (.valerianellaLocusta, .valerianellaLocusta): return true
      case (.viciaFaba, .viciaFaba): return true
      case (.viciaSativa, .viciaSativa): return true
      case (.zeaMays, .zeaMays): return true
      case (.zeaMaysSaccharata, .zeaMaysSaccharata): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// StorageType
public enum StorageTypeEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case heap
  case silo
  case building
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "HEAP": self = .heap
      case "SILO": self = .silo
      case "BUILDING": self = .building
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .heap: return "HEAP"
      case .silo: return "SILO"
      case .building: return "BUILDING"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: StorageTypeEnum, rhs: StorageTypeEnum) -> Bool {
    switch (lhs, rhs) {
      case (.heap, .heap): return true
      case (.silo, .silo): return true
      case (.building, .building): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// EquipmentTypeEnum
public enum EquipmentTypeEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case airplanter
  case balerWrapper
  case cornTopper
  case cubicBaler
  case discHarrow
  case foragePlatform
  case forager
  case grinder
  case harrow
  case harvester
  case hayRake
  case hiller
  case hoe
  case hoeWeeder
  case implanter
  case irrigationPivot
  case liquidManureSpreader
  case mower
  case mowerConditioner
  case plow
  case reaper
  case roll
  case rotaryHoe
  case roundBaler
  case seedbedPreparator
  case soilLoosener
  case sower
  case sprayer
  case spreader
  case spreaderTrailer
  case subsoilPlow
  case superficialPlow
  case tedder
  case topper
  case tractor
  case trailer
  case trimmer
  case vibrocultivator
  case waterSpreader
  case weeder
  case wrapper
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "AIRPLANTER": self = .airplanter
      case "BALER_WRAPPER": self = .balerWrapper
      case "CORN_TOPPER": self = .cornTopper
      case "CUBIC_BALER": self = .cubicBaler
      case "DISC_HARROW": self = .discHarrow
      case "FORAGE_PLATFORM": self = .foragePlatform
      case "FORAGER": self = .forager
      case "GRINDER": self = .grinder
      case "HARROW": self = .harrow
      case "HARVESTER": self = .harvester
      case "HAY_RAKE": self = .hayRake
      case "HILLER": self = .hiller
      case "HOE": self = .hoe
      case "HOE_WEEDER": self = .hoeWeeder
      case "IMPLANTER": self = .implanter
      case "IRRIGATION_PIVOT": self = .irrigationPivot
      case "LIQUID_MANURE_SPREADER": self = .liquidManureSpreader
      case "MOWER": self = .mower
      case "MOWER_CONDITIONER": self = .mowerConditioner
      case "PLOW": self = .plow
      case "REAPER": self = .reaper
      case "ROLL": self = .roll
      case "ROTARY_HOE": self = .rotaryHoe
      case "ROUND_BALER": self = .roundBaler
      case "SEEDBED_PREPARATOR": self = .seedbedPreparator
      case "SOIL_LOOSENER": self = .soilLoosener
      case "SOWER": self = .sower
      case "SPRAYER": self = .sprayer
      case "SPREADER": self = .spreader
      case "SPREADER_TRAILER": self = .spreaderTrailer
      case "SUBSOIL_PLOW": self = .subsoilPlow
      case "SUPERFICIAL_PLOW": self = .superficialPlow
      case "TEDDER": self = .tedder
      case "TOPPER": self = .topper
      case "TRACTOR": self = .tractor
      case "TRAILER": self = .trailer
      case "TRIMMER": self = .trimmer
      case "VIBROCULTIVATOR": self = .vibrocultivator
      case "WATER_SPREADER": self = .waterSpreader
      case "WEEDER": self = .weeder
      case "WRAPPER": self = .wrapper
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .airplanter: return "AIRPLANTER"
      case .balerWrapper: return "BALER_WRAPPER"
      case .cornTopper: return "CORN_TOPPER"
      case .cubicBaler: return "CUBIC_BALER"
      case .discHarrow: return "DISC_HARROW"
      case .foragePlatform: return "FORAGE_PLATFORM"
      case .forager: return "FORAGER"
      case .grinder: return "GRINDER"
      case .harrow: return "HARROW"
      case .harvester: return "HARVESTER"
      case .hayRake: return "HAY_RAKE"
      case .hiller: return "HILLER"
      case .hoe: return "HOE"
      case .hoeWeeder: return "HOE_WEEDER"
      case .implanter: return "IMPLANTER"
      case .irrigationPivot: return "IRRIGATION_PIVOT"
      case .liquidManureSpreader: return "LIQUID_MANURE_SPREADER"
      case .mower: return "MOWER"
      case .mowerConditioner: return "MOWER_CONDITIONER"
      case .plow: return "PLOW"
      case .reaper: return "REAPER"
      case .roll: return "ROLL"
      case .rotaryHoe: return "ROTARY_HOE"
      case .roundBaler: return "ROUND_BALER"
      case .seedbedPreparator: return "SEEDBED_PREPARATOR"
      case .soilLoosener: return "SOIL_LOOSENER"
      case .sower: return "SOWER"
      case .sprayer: return "SPRAYER"
      case .spreader: return "SPREADER"
      case .spreaderTrailer: return "SPREADER_TRAILER"
      case .subsoilPlow: return "SUBSOIL_PLOW"
      case .superficialPlow: return "SUPERFICIAL_PLOW"
      case .tedder: return "TEDDER"
      case .topper: return "TOPPER"
      case .tractor: return "TRACTOR"
      case .trailer: return "TRAILER"
      case .trimmer: return "TRIMMER"
      case .vibrocultivator: return "VIBROCULTIVATOR"
      case .waterSpreader: return "WATER_SPREADER"
      case .weeder: return "WEEDER"
      case .wrapper: return "WRAPPER"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: EquipmentTypeEnum, rhs: EquipmentTypeEnum) -> Bool {
    switch (lhs, rhs) {
      case (.airplanter, .airplanter): return true
      case (.balerWrapper, .balerWrapper): return true
      case (.cornTopper, .cornTopper): return true
      case (.cubicBaler, .cubicBaler): return true
      case (.discHarrow, .discHarrow): return true
      case (.foragePlatform, .foragePlatform): return true
      case (.forager, .forager): return true
      case (.grinder, .grinder): return true
      case (.harrow, .harrow): return true
      case (.harvester, .harvester): return true
      case (.hayRake, .hayRake): return true
      case (.hiller, .hiller): return true
      case (.hoe, .hoe): return true
      case (.hoeWeeder, .hoeWeeder): return true
      case (.implanter, .implanter): return true
      case (.irrigationPivot, .irrigationPivot): return true
      case (.liquidManureSpreader, .liquidManureSpreader): return true
      case (.mower, .mower): return true
      case (.mowerConditioner, .mowerConditioner): return true
      case (.plow, .plow): return true
      case (.reaper, .reaper): return true
      case (.roll, .roll): return true
      case (.rotaryHoe, .rotaryHoe): return true
      case (.roundBaler, .roundBaler): return true
      case (.seedbedPreparator, .seedbedPreparator): return true
      case (.soilLoosener, .soilLoosener): return true
      case (.sower, .sower): return true
      case (.sprayer, .sprayer): return true
      case (.spreader, .spreader): return true
      case (.spreaderTrailer, .spreaderTrailer): return true
      case (.subsoilPlow, .subsoilPlow): return true
      case (.superficialPlow, .superficialPlow): return true
      case (.tedder, .tedder): return true
      case (.topper, .topper): return true
      case (.tractor, .tractor): return true
      case (.trailer, .trailer): return true
      case (.trimmer, .trimmer): return true
      case (.vibrocultivator, .vibrocultivator): return true
      case (.waterSpreader, .waterSpreader): return true
      case (.weeder, .weeder): return true
      case (.wrapper, .wrapper): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

/// Intervention target attributes : Fill workZone to override workZone of crop
public struct InterventionTargetAttributes: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(cropId: Swift.Optional<GraphQLID?> = nil, workZone: Swift.Optional<String?> = nil, workAreaPercentage: Int) {
    graphQLMap = ["cropID": cropId, "workZone": workZone, "workAreaPercentage": workAreaPercentage]
  }

  public var cropId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["cropID"] as! Swift.Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "cropID")
    }
  }

  public var workZone: Swift.Optional<String?> {
    get {
      return graphQLMap["workZone"] as! Swift.Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "workZone")
    }
  }

  public var workAreaPercentage: Int {
    get {
      return graphQLMap["workAreaPercentage"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "workAreaPercentage")
    }
  }
}

/// Intervention working day attributes : Date format : DD/MM/YYYY
public struct InterventionWorkingDayAttributes: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(executionDate: String, hourDuration: Swift.Optional<Double?> = nil) {
    graphQLMap = ["executionDate": executionDate, "hourDuration": hourDuration]
  }

  public var executionDate: String {
    get {
      return graphQLMap["executionDate"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "executionDate")
    }
  }

  public var hourDuration: Swift.Optional<Double?> {
    get {
      return graphQLMap["hourDuration"] as! Swift.Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "hourDuration")
    }
  }
}

/// Intervention input attributes
public struct InterventionInputAttributes: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(marketingAuthorizationNumber: Swift.Optional<String?> = nil, article: Swift.Optional<InterventionArticleAttributes?> = nil, quantity: Double, unit: ArticleAllUnitEnum, unitPrice: Swift.Optional<Int?> = nil) {
    graphQLMap = ["marketingAuthorizationNumber": marketingAuthorizationNumber, "article": article, "quantity": quantity, "unit": unit, "unitPrice": unitPrice]
  }

  public var marketingAuthorizationNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["marketingAuthorizationNumber"] as! Swift.Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "marketingAuthorizationNumber")
    }
  }

  public var article: Swift.Optional<InterventionArticleAttributes?> {
    get {
      return graphQLMap["article"] as! Swift.Optional<InterventionArticleAttributes?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "article")
    }
  }

  public var quantity: Double {
    get {
      return graphQLMap["quantity"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "quantity")
    }
  }

  public var unit: ArticleAllUnitEnum {
    get {
      return graphQLMap["unit"] as! ArticleAllUnitEnum
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "unit")
    }
  }

  public var unitPrice: Swift.Optional<Int?> {
    get {
      return graphQLMap["unitPrice"] as! Swift.Optional<Int?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "unitPrice")
    }
  }
}

/// Case 1: Provide 'id' --- Case 2: Provide 'referenceID' + 'type'
public struct InterventionArticleAttributes: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: Swift.Optional<GraphQLID?> = nil, referenceId: Swift.Optional<GraphQLID?> = nil, type: Swift.Optional<ArticleTypeEnum?> = nil) {
    graphQLMap = ["id": id, "referenceID": referenceId, "type": type]
  }

  public var id: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["id"] as! Swift.Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var referenceId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["referenceID"] as! Swift.Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "referenceID")
    }
  }

  public var type: Swift.Optional<ArticleTypeEnum?> {
    get {
      return graphQLMap["type"] as! Swift.Optional<ArticleTypeEnum?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }
}

/// Intervention output attributes
public struct InterventionOutputAttributes: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(quantity: Swift.Optional<Double?> = nil, nature: Swift.Optional<InterventionOutputTypeEnum?> = nil, unit: Swift.Optional<InterventionOutputUnitEnum?> = nil, approximative: Swift.Optional<Bool?> = nil, loads: Swift.Optional<[HarvestLoadAttributes]?> = nil) {
    graphQLMap = ["quantity": quantity, "nature": nature, "unit": unit, "approximative": approximative, "loads": loads]
  }

  public var quantity: Swift.Optional<Double?> {
    get {
      return graphQLMap["quantity"] as! Swift.Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "quantity")
    }
  }

  public var nature: Swift.Optional<InterventionOutputTypeEnum?> {
    get {
      return graphQLMap["nature"] as! Swift.Optional<InterventionOutputTypeEnum?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nature")
    }
  }

  public var unit: Swift.Optional<InterventionOutputUnitEnum?> {
    get {
      return graphQLMap["unit"] as! Swift.Optional<InterventionOutputUnitEnum?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "unit")
    }
  }

  public var approximative: Swift.Optional<Bool?> {
    get {
      return graphQLMap["approximative"] as! Swift.Optional<Bool?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "approximative")
    }
  }

  public var loads: Swift.Optional<[HarvestLoadAttributes]?> {
    get {
      return graphQLMap["loads"] as! Swift.Optional<[HarvestLoadAttributes]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loads")
    }
  }
}

/// Harvest load attributes
public struct HarvestLoadAttributes: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(quantity: Double, netQuantity: Swift.Optional<Double?> = nil, unit: Swift.Optional<HarvestLoadUnitEnum?> = nil, number: Swift.Optional<String?> = nil, storageId: Swift.Optional<GraphQLID?> = nil) {
    graphQLMap = ["quantity": quantity, "netQuantity": netQuantity, "unit": unit, "number": number, "storageID": storageId]
  }

  public var quantity: Double {
    get {
      return graphQLMap["quantity"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "quantity")
    }
  }

  public var netQuantity: Swift.Optional<Double?> {
    get {
      return graphQLMap["netQuantity"] as! Swift.Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "netQuantity")
    }
  }

  public var unit: Swift.Optional<HarvestLoadUnitEnum?> {
    get {
      return graphQLMap["unit"] as! Swift.Optional<HarvestLoadUnitEnum?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "unit")
    }
  }

  public var number: Swift.Optional<String?> {
    get {
      return graphQLMap["number"] as! Swift.Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "number")
    }
  }

  public var storageId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["storageID"] as! Swift.Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "storageID")
    }
  }
}

/// Intervention tool attributes
public struct InterventionToolAttributes: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(equipmentId: Swift.Optional<GraphQLID?> = nil) {
    graphQLMap = ["equipmentID": equipmentId]
  }

  public var equipmentId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["equipmentID"] as! Swift.Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "equipmentID")
    }
  }
}

/// Intervention operator attributes
public struct InterventionOperatorAttributes: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(personId: Swift.Optional<GraphQLID?> = nil, role: Swift.Optional<OperatorRoleEnum?> = nil) {
    graphQLMap = ["personID": personId, "role": role]
  }

  public var personId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["personID"] as! Swift.Optional<GraphQLID?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "personID")
    }
  }

  public var role: Swift.Optional<OperatorRoleEnum?> {
    get {
      return graphQLMap["role"] as! Swift.Optional<OperatorRoleEnum?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "role")
    }
  }
}

/// WeatherInputObject
public struct WeatherAttributes: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(windSpeed: Swift.Optional<Double?> = nil, temperature: Swift.Optional<Double?> = nil, description: Swift.Optional<WeatherEnum?> = nil) {
    graphQLMap = ["windSpeed": windSpeed, "temperature": temperature, "description": description]
  }

  public var windSpeed: Swift.Optional<Double?> {
    get {
      return graphQLMap["windSpeed"] as! Swift.Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "windSpeed")
    }
  }

  public var temperature: Swift.Optional<Double?> {
    get {
      return graphQLMap["temperature"] as! Swift.Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "temperature")
    }
  }

  public var description: Swift.Optional<WeatherEnum?> {
    get {
      return graphQLMap["description"] as! Swift.Optional<WeatherEnum?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }
}

/// ArticleVolumeUnit
public enum ArticleVolumeUnitEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case liter
  case literPerSquareMeter
  case literPerHectare
  case cubicMeter
  case cubicMeterPerSquareMeter
  case cubicMeterPerHectare
  case hectoliter
  case hectoliterPerSquareMeter
  case hectoliterPerHectare
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "LITER": self = .liter
      case "LITER_PER_SQUARE_METER": self = .literPerSquareMeter
      case "LITER_PER_HECTARE": self = .literPerHectare
      case "CUBIC_METER": self = .cubicMeter
      case "CUBIC_METER_PER_SQUARE_METER": self = .cubicMeterPerSquareMeter
      case "CUBIC_METER_PER_HECTARE": self = .cubicMeterPerHectare
      case "HECTOLITER": self = .hectoliter
      case "HECTOLITER_PER_SQUARE_METER": self = .hectoliterPerSquareMeter
      case "HECTOLITER_PER_HECTARE": self = .hectoliterPerHectare
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .liter: return "LITER"
      case .literPerSquareMeter: return "LITER_PER_SQUARE_METER"
      case .literPerHectare: return "LITER_PER_HECTARE"
      case .cubicMeter: return "CUBIC_METER"
      case .cubicMeterPerSquareMeter: return "CUBIC_METER_PER_SQUARE_METER"
      case .cubicMeterPerHectare: return "CUBIC_METER_PER_HECTARE"
      case .hectoliter: return "HECTOLITER"
      case .hectoliterPerSquareMeter: return "HECTOLITER_PER_SQUARE_METER"
      case .hectoliterPerHectare: return "HECTOLITER_PER_HECTARE"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ArticleVolumeUnitEnum, rhs: ArticleVolumeUnitEnum) -> Bool {
    switch (lhs, rhs) {
      case (.liter, .liter): return true
      case (.literPerSquareMeter, .literPerSquareMeter): return true
      case (.literPerHectare, .literPerHectare): return true
      case (.cubicMeter, .cubicMeter): return true
      case (.cubicMeterPerSquareMeter, .cubicMeterPerSquareMeter): return true
      case (.cubicMeterPerHectare, .cubicMeterPerHectare): return true
      case (.hectoliter, .hectoliter): return true
      case (.hectoliterPerSquareMeter, .hectoliterPerSquareMeter): return true
      case (.hectoliterPerHectare, .hectoliterPerHectare): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public final class ProfileQuery: GraphQLQuery {
  public let operationDefinition =
    "query Profile {\n  profile {\n    __typename\n    firstName\n    lastName\n  }\n  farms {\n    __typename\n    label\n    id\n    platform\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("profile", type: .nonNull(.object(Profile.selections))),
      GraphQLField("farms", type: .nonNull(.list(.nonNull(.object(Farm.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(profile: Profile, farms: [Farm]) {
      self.init(unsafeResultMap: ["__typename": "Query", "profile": profile.resultMap, "farms": farms.map { (value: Farm) -> ResultMap in value.resultMap }])
    }

    public var profile: Profile {
      get {
        return Profile(unsafeResultMap: resultMap["profile"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "profile")
      }
    }

    public var farms: [Farm] {
      get {
        return (resultMap["farms"] as! [ResultMap]).map { (value: ResultMap) -> Farm in Farm(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Farm) -> ResultMap in value.resultMap }, forKey: "farms")
      }
    }

    public struct Profile: GraphQLSelectionSet {
      public static let possibleTypes = ["Profile"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("firstName", type: .scalar(String.self)),
        GraphQLField("lastName", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(firstName: String? = nil, lastName: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Profile", "firstName": firstName, "lastName": lastName])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var firstName: String? {
        get {
          return resultMap["firstName"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "firstName")
        }
      }

      public var lastName: String? {
        get {
          return resultMap["lastName"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "lastName")
        }
      }
    }

    public struct Farm: GraphQLSelectionSet {
      public static let possibleTypes = ["Farm"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("label", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
        GraphQLField("platform", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(label: String, id: String, platform: String) {
        self.init(unsafeResultMap: ["__typename": "Farm", "label": label, "id": id, "platform": platform])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var label: String {
        get {
          return resultMap["label"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "label")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var platform: String {
        get {
          return resultMap["platform"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "platform")
        }
      }
    }
  }
}

public final class InterventionQuery: GraphQLQuery {
  public let operationDefinition =
    "query Intervention {\n  farms {\n    __typename\n    id\n    interventions {\n      __typename\n      id\n      type\n      validatedAt\n      waterQuantity\n      waterUnit\n      globalOutputs\n      description\n      weather {\n        __typename\n        temperature\n        windSpeed\n        description\n      }\n      outputs {\n        __typename\n        id\n        nature\n        approximative\n        quantity\n        unit\n        loads {\n          __typename\n          number\n          quantity\n          netQuantity\n          unit\n          storage {\n            __typename\n            id\n          }\n        }\n      }\n      inputs {\n        __typename\n        article {\n          __typename\n          id\n          referenceID\n          type\n        }\n        quantity\n        unit\n      }\n      operators {\n        __typename\n        id\n        role\n        person {\n          __typename\n          id\n        }\n      }\n      targets {\n        __typename\n        crop {\n          __typename\n          uuid\n        }\n        workingPercentage\n      }\n      tools {\n        __typename\n        equipment {\n          __typename\n          id\n        }\n      }\n      workingDays {\n        __typename\n        executionDate\n        hourDuration\n      }\n    }\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("farms", type: .nonNull(.list(.nonNull(.object(Farm.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(farms: [Farm]) {
      self.init(unsafeResultMap: ["__typename": "Query", "farms": farms.map { (value: Farm) -> ResultMap in value.resultMap }])
    }

    public var farms: [Farm] {
      get {
        return (resultMap["farms"] as! [ResultMap]).map { (value: ResultMap) -> Farm in Farm(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Farm) -> ResultMap in value.resultMap }, forKey: "farms")
      }
    }

    public struct Farm: GraphQLSelectionSet {
      public static let possibleTypes = ["Farm"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
        GraphQLField("interventions", type: .nonNull(.list(.nonNull(.object(Intervention.selections))))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, interventions: [Intervention]) {
        self.init(unsafeResultMap: ["__typename": "Farm", "id": id, "interventions": interventions.map { (value: Intervention) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var interventions: [Intervention] {
        get {
          return (resultMap["interventions"] as! [ResultMap]).map { (value: ResultMap) -> Intervention in Intervention(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Intervention) -> ResultMap in value.resultMap }, forKey: "interventions")
        }
      }

      public struct Intervention: GraphQLSelectionSet {
        public static let possibleTypes = ["Intervention"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(InterventionTypeEnum.self))),
          GraphQLField("validatedAt", type: .scalar(String.self)),
          GraphQLField("waterQuantity", type: .scalar(Int.self)),
          GraphQLField("waterUnit", type: .scalar(InterventionWaterVolumeUnitEnum.self)),
          GraphQLField("globalOutputs", type: .scalar(Bool.self)),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("weather", type: .object(Weather.selections)),
          GraphQLField("outputs", type: .list(.nonNull(.object(Output.selections)))),
          GraphQLField("inputs", type: .list(.nonNull(.object(Input.selections)))),
          GraphQLField("operators", type: .list(.nonNull(.object(Operator.selections)))),
          GraphQLField("targets", type: .nonNull(.list(.nonNull(.object(Target.selections))))),
          GraphQLField("tools", type: .list(.nonNull(.object(Tool.selections)))),
          GraphQLField("workingDays", type: .nonNull(.list(.nonNull(.object(WorkingDay.selections))))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, type: InterventionTypeEnum, validatedAt: String? = nil, waterQuantity: Int? = nil, waterUnit: InterventionWaterVolumeUnitEnum? = nil, globalOutputs: Bool? = nil, description: String? = nil, weather: Weather? = nil, outputs: [Output]? = nil, inputs: [Input]? = nil, operators: [Operator]? = nil, targets: [Target], tools: [Tool]? = nil, workingDays: [WorkingDay]) {
          self.init(unsafeResultMap: ["__typename": "Intervention", "id": id, "type": type, "validatedAt": validatedAt, "waterQuantity": waterQuantity, "waterUnit": waterUnit, "globalOutputs": globalOutputs, "description": description, "weather": weather.flatMap { (value: Weather) -> ResultMap in value.resultMap }, "outputs": outputs.flatMap { (value: [Output]) -> [ResultMap] in value.map { (value: Output) -> ResultMap in value.resultMap } }, "inputs": inputs.flatMap { (value: [Input]) -> [ResultMap] in value.map { (value: Input) -> ResultMap in value.resultMap } }, "operators": operators.flatMap { (value: [Operator]) -> [ResultMap] in value.map { (value: Operator) -> ResultMap in value.resultMap } }, "targets": targets.map { (value: Target) -> ResultMap in value.resultMap }, "tools": tools.flatMap { (value: [Tool]) -> [ResultMap] in value.map { (value: Tool) -> ResultMap in value.resultMap } }, "workingDays": workingDays.map { (value: WorkingDay) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var type: InterventionTypeEnum {
          get {
            return resultMap["type"]! as! InterventionTypeEnum
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var validatedAt: String? {
          get {
            return resultMap["validatedAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "validatedAt")
          }
        }

        public var waterQuantity: Int? {
          get {
            return resultMap["waterQuantity"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "waterQuantity")
          }
        }

        public var waterUnit: InterventionWaterVolumeUnitEnum? {
          get {
            return resultMap["waterUnit"] as? InterventionWaterVolumeUnitEnum
          }
          set {
            resultMap.updateValue(newValue, forKey: "waterUnit")
          }
        }

        public var globalOutputs: Bool? {
          get {
            return resultMap["globalOutputs"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "globalOutputs")
          }
        }

        public var description: String? {
          get {
            return resultMap["description"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }

        public var weather: Weather? {
          get {
            return (resultMap["weather"] as? ResultMap).flatMap { Weather(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "weather")
          }
        }

        public var outputs: [Output]? {
          get {
            return (resultMap["outputs"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Output] in value.map { (value: ResultMap) -> Output in Output(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Output]) -> [ResultMap] in value.map { (value: Output) -> ResultMap in value.resultMap } }, forKey: "outputs")
          }
        }

        public var inputs: [Input]? {
          get {
            return (resultMap["inputs"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Input] in value.map { (value: ResultMap) -> Input in Input(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Input]) -> [ResultMap] in value.map { (value: Input) -> ResultMap in value.resultMap } }, forKey: "inputs")
          }
        }

        public var operators: [Operator]? {
          get {
            return (resultMap["operators"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Operator] in value.map { (value: ResultMap) -> Operator in Operator(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Operator]) -> [ResultMap] in value.map { (value: Operator) -> ResultMap in value.resultMap } }, forKey: "operators")
          }
        }

        public var targets: [Target] {
          get {
            return (resultMap["targets"] as! [ResultMap]).map { (value: ResultMap) -> Target in Target(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Target) -> ResultMap in value.resultMap }, forKey: "targets")
          }
        }

        public var tools: [Tool]? {
          get {
            return (resultMap["tools"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Tool] in value.map { (value: ResultMap) -> Tool in Tool(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Tool]) -> [ResultMap] in value.map { (value: Tool) -> ResultMap in value.resultMap } }, forKey: "tools")
          }
        }

        public var workingDays: [WorkingDay] {
          get {
            return (resultMap["workingDays"] as! [ResultMap]).map { (value: ResultMap) -> WorkingDay in WorkingDay(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: WorkingDay) -> ResultMap in value.resultMap }, forKey: "workingDays")
          }
        }

        public struct Weather: GraphQLSelectionSet {
          public static let possibleTypes = ["Weather"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("temperature", type: .scalar(Double.self)),
            GraphQLField("windSpeed", type: .scalar(Double.self)),
            GraphQLField("description", type: .scalar(WeatherEnum.self)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(temperature: Double? = nil, windSpeed: Double? = nil, description: WeatherEnum? = nil) {
            self.init(unsafeResultMap: ["__typename": "Weather", "temperature": temperature, "windSpeed": windSpeed, "description": description])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Measured in Celsius
          public var temperature: Double? {
            get {
              return resultMap["temperature"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "temperature")
            }
          }

          /// Measured in km/h
          public var windSpeed: Double? {
            get {
              return resultMap["windSpeed"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "windSpeed")
            }
          }

          public var description: WeatherEnum? {
            get {
              return resultMap["description"] as? WeatherEnum
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }

        public struct Output: GraphQLSelectionSet {
          public static let possibleTypes = ["InterventionOutput"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("nature", type: .nonNull(.scalar(InterventionOutputTypeEnum.self))),
            GraphQLField("approximative", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("quantity", type: .scalar(Double.self)),
            GraphQLField("unit", type: .scalar(InterventionOutputUnitEnum.self)),
            GraphQLField("loads", type: .list(.nonNull(.object(Load.selections)))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, nature: InterventionOutputTypeEnum, approximative: Bool, quantity: Double? = nil, unit: InterventionOutputUnitEnum? = nil, loads: [Load]? = nil) {
            self.init(unsafeResultMap: ["__typename": "InterventionOutput", "id": id, "nature": nature, "approximative": approximative, "quantity": quantity, "unit": unit, "loads": loads.flatMap { (value: [Load]) -> [ResultMap] in value.map { (value: Load) -> ResultMap in value.resultMap } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var nature: InterventionOutputTypeEnum {
            get {
              return resultMap["nature"]! as! InterventionOutputTypeEnum
            }
            set {
              resultMap.updateValue(newValue, forKey: "nature")
            }
          }

          public var approximative: Bool {
            get {
              return resultMap["approximative"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "approximative")
            }
          }

          public var quantity: Double? {
            get {
              return resultMap["quantity"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "quantity")
            }
          }

          public var unit: InterventionOutputUnitEnum? {
            get {
              return resultMap["unit"] as? InterventionOutputUnitEnum
            }
            set {
              resultMap.updateValue(newValue, forKey: "unit")
            }
          }

          public var loads: [Load]? {
            get {
              return (resultMap["loads"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Load] in value.map { (value: ResultMap) -> Load in Load(unsafeResultMap: value) } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Load]) -> [ResultMap] in value.map { (value: Load) -> ResultMap in value.resultMap } }, forKey: "loads")
            }
          }

          public struct Load: GraphQLSelectionSet {
            public static let possibleTypes = ["HarvestLoad"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("number", type: .nonNull(.scalar(String.self))),
              GraphQLField("quantity", type: .nonNull(.scalar(Double.self))),
              GraphQLField("netQuantity", type: .scalar(Double.self)),
              GraphQLField("unit", type: .scalar(HarvestLoadUnitEnum.self)),
              GraphQLField("storage", type: .object(Storage.selections)),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(number: String, quantity: Double, netQuantity: Double? = nil, unit: HarvestLoadUnitEnum? = nil, storage: Storage? = nil) {
              self.init(unsafeResultMap: ["__typename": "HarvestLoad", "number": number, "quantity": quantity, "netQuantity": netQuantity, "unit": unit, "storage": storage.flatMap { (value: Storage) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var number: String {
              get {
                return resultMap["number"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "number")
              }
            }

            public var quantity: Double {
              get {
                return resultMap["quantity"]! as! Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "quantity")
              }
            }

            public var netQuantity: Double? {
              get {
                return resultMap["netQuantity"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "netQuantity")
              }
            }

            public var unit: HarvestLoadUnitEnum? {
              get {
                return resultMap["unit"] as? HarvestLoadUnitEnum
              }
              set {
                resultMap.updateValue(newValue, forKey: "unit")
              }
            }

            public var storage: Storage? {
              get {
                return (resultMap["storage"] as? ResultMap).flatMap { Storage(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "storage")
              }
            }

            public struct Storage: GraphQLSelectionSet {
              public static let possibleTypes = ["Storage"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              ]

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: GraphQLID) {
                self.init(unsafeResultMap: ["__typename": "Storage", "id": id])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID {
                get {
                  return resultMap["id"]! as! GraphQLID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }
            }
          }
        }

        public struct Input: GraphQLSelectionSet {
          public static let possibleTypes = ["InterventionInput"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("article", type: .object(Article.selections)),
            GraphQLField("quantity", type: .scalar(Double.self)),
            GraphQLField("unit", type: .nonNull(.scalar(ArticleAllUnitEnum.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(article: Article? = nil, quantity: Double? = nil, unit: ArticleAllUnitEnum) {
            self.init(unsafeResultMap: ["__typename": "InterventionInput", "article": article.flatMap { (value: Article) -> ResultMap in value.resultMap }, "quantity": quantity, "unit": unit])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var article: Article? {
            get {
              return (resultMap["article"] as? ResultMap).flatMap { Article(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "article")
            }
          }

          public var quantity: Double? {
            get {
              return resultMap["quantity"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "quantity")
            }
          }

          public var unit: ArticleAllUnitEnum {
            get {
              return resultMap["unit"]! as! ArticleAllUnitEnum
            }
            set {
              resultMap.updateValue(newValue, forKey: "unit")
            }
          }

          public struct Article: GraphQLSelectionSet {
            public static let possibleTypes = ["Article"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("referenceID", type: .scalar(GraphQLID.self)),
              GraphQLField("type", type: .nonNull(.scalar(ArticleTypeEnum.self))),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID, referenceId: GraphQLID? = nil, type: ArticleTypeEnum) {
              self.init(unsafeResultMap: ["__typename": "Article", "id": id, "referenceID": referenceId, "type": type])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return resultMap["id"]! as! GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }

            public var referenceId: GraphQLID? {
              get {
                return resultMap["referenceID"] as? GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "referenceID")
              }
            }

            public var type: ArticleTypeEnum {
              get {
                return resultMap["type"]! as! ArticleTypeEnum
              }
              set {
                resultMap.updateValue(newValue, forKey: "type")
              }
            }
          }
        }

        public struct Operator: GraphQLSelectionSet {
          public static let possibleTypes = ["InterventionOperator"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("role", type: .scalar(OperatorRoleEnum.self)),
            GraphQLField("person", type: .object(Person.selections)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, role: OperatorRoleEnum? = nil, person: Person? = nil) {
            self.init(unsafeResultMap: ["__typename": "InterventionOperator", "id": id, "role": role, "person": person.flatMap { (value: Person) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var role: OperatorRoleEnum? {
            get {
              return resultMap["role"] as? OperatorRoleEnum
            }
            set {
              resultMap.updateValue(newValue, forKey: "role")
            }
          }

          public var person: Person? {
            get {
              return (resultMap["person"] as? ResultMap).flatMap { Person(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "person")
            }
          }

          public struct Person: GraphQLSelectionSet {
            public static let possibleTypes = ["Person"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID) {
              self.init(unsafeResultMap: ["__typename": "Person", "id": id])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return resultMap["id"]! as! GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }
          }
        }

        public struct Target: GraphQLSelectionSet {
          public static let possibleTypes = ["InterventionTarget"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("crop", type: .nonNull(.object(Crop.selections))),
            GraphQLField("workingPercentage", type: .nonNull(.scalar(Int.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(crop: Crop, workingPercentage: Int) {
            self.init(unsafeResultMap: ["__typename": "InterventionTarget", "crop": crop.resultMap, "workingPercentage": workingPercentage])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var crop: Crop {
            get {
              return Crop(unsafeResultMap: resultMap["crop"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "crop")
            }
          }

          public var workingPercentage: Int {
            get {
              return resultMap["workingPercentage"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "workingPercentage")
            }
          }

          public struct Crop: GraphQLSelectionSet {
            public static let possibleTypes = ["Crop"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("uuid", type: .nonNull(.scalar(String.self))),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(uuid: String) {
              self.init(unsafeResultMap: ["__typename": "Crop", "uuid": uuid])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var uuid: String {
              get {
                return resultMap["uuid"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "uuid")
              }
            }
          }
        }

        public struct Tool: GraphQLSelectionSet {
          public static let possibleTypes = ["InterventionTool"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("equipment", type: .object(Equipment.selections)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(equipment: Equipment? = nil) {
            self.init(unsafeResultMap: ["__typename": "InterventionTool", "equipment": equipment.flatMap { (value: Equipment) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var equipment: Equipment? {
            get {
              return (resultMap["equipment"] as? ResultMap).flatMap { Equipment(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "equipment")
            }
          }

          public struct Equipment: GraphQLSelectionSet {
            public static let possibleTypes = ["Equipment"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            ]

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID) {
              self.init(unsafeResultMap: ["__typename": "Equipment", "id": id])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return resultMap["id"]! as! GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }
          }
        }

        public struct WorkingDay: GraphQLSelectionSet {
          public static let possibleTypes = ["InterventionWorkingDay"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("executionDate", type: .scalar(String.self)),
            GraphQLField("hourDuration", type: .scalar(Double.self)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(executionDate: String? = nil, hourDuration: Double? = nil) {
            self.init(unsafeResultMap: ["__typename": "InterventionWorkingDay", "executionDate": executionDate, "hourDuration": hourDuration])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var executionDate: String? {
            get {
              return resultMap["executionDate"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "executionDate")
            }
          }

          public var hourDuration: Double? {
            get {
              return resultMap["hourDuration"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "hourDuration")
            }
          }
        }
      }
    }
  }
}

public final class FarmQuery: GraphQLQuery {
  public let operationDefinition =
    "query Farm {\n  farms {\n    __typename\n    id\n    label\n    articles {\n      __typename\n      id\n      type\n      name\n      referenceID\n      unit\n      species\n      variety\n      marketingAuthorizationNumber\n    }\n    storages {\n      __typename\n      id\n      name\n      type\n    }\n    plots {\n      __typename\n      uuid\n      name\n      surfaceArea\n    }\n    crops {\n      __typename\n      uuid\n      name\n      species\n      productionMode\n      provisionalYield\n      startDate\n      stopDate\n      surfaceArea\n    }\n    people {\n      __typename\n      id\n      firstName\n      lastName\n    }\n    equipments {\n      __typename\n      id\n      name\n      type\n      number\n    }\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("farms", type: .nonNull(.list(.nonNull(.object(Farm.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(farms: [Farm]) {
      self.init(unsafeResultMap: ["__typename": "Query", "farms": farms.map { (value: Farm) -> ResultMap in value.resultMap }])
    }

    public var farms: [Farm] {
      get {
        return (resultMap["farms"] as! [ResultMap]).map { (value: ResultMap) -> Farm in Farm(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Farm) -> ResultMap in value.resultMap }, forKey: "farms")
      }
    }

    public struct Farm: GraphQLSelectionSet {
      public static let possibleTypes = ["Farm"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
        GraphQLField("label", type: .nonNull(.scalar(String.self))),
        GraphQLField("articles", type: .nonNull(.list(.nonNull(.object(Article.selections))))),
        GraphQLField("storages", type: .nonNull(.list(.nonNull(.object(Storage.selections))))),
        GraphQLField("plots", type: .nonNull(.list(.nonNull(.object(Plot.selections))))),
        GraphQLField("crops", type: .nonNull(.list(.nonNull(.object(Crop.selections))))),
        GraphQLField("people", type: .nonNull(.list(.nonNull(.object(Person.selections))))),
        GraphQLField("equipments", type: .nonNull(.list(.nonNull(.object(Equipment.selections))))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, label: String, articles: [Article], storages: [Storage], plots: [Plot], crops: [Crop], people: [Person], equipments: [Equipment]) {
        self.init(unsafeResultMap: ["__typename": "Farm", "id": id, "label": label, "articles": articles.map { (value: Article) -> ResultMap in value.resultMap }, "storages": storages.map { (value: Storage) -> ResultMap in value.resultMap }, "plots": plots.map { (value: Plot) -> ResultMap in value.resultMap }, "crops": crops.map { (value: Crop) -> ResultMap in value.resultMap }, "people": people.map { (value: Person) -> ResultMap in value.resultMap }, "equipments": equipments.map { (value: Equipment) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var label: String {
        get {
          return resultMap["label"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "label")
        }
      }

      public var articles: [Article] {
        get {
          return (resultMap["articles"] as! [ResultMap]).map { (value: ResultMap) -> Article in Article(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Article) -> ResultMap in value.resultMap }, forKey: "articles")
        }
      }

      public var storages: [Storage] {
        get {
          return (resultMap["storages"] as! [ResultMap]).map { (value: ResultMap) -> Storage in Storage(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Storage) -> ResultMap in value.resultMap }, forKey: "storages")
        }
      }

      public var plots: [Plot] {
        get {
          return (resultMap["plots"] as! [ResultMap]).map { (value: ResultMap) -> Plot in Plot(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Plot) -> ResultMap in value.resultMap }, forKey: "plots")
        }
      }

      public var crops: [Crop] {
        get {
          return (resultMap["crops"] as! [ResultMap]).map { (value: ResultMap) -> Crop in Crop(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Crop) -> ResultMap in value.resultMap }, forKey: "crops")
        }
      }

      public var people: [Person] {
        get {
          return (resultMap["people"] as! [ResultMap]).map { (value: ResultMap) -> Person in Person(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Person) -> ResultMap in value.resultMap }, forKey: "people")
        }
      }

      public var equipments: [Equipment] {
        get {
          return (resultMap["equipments"] as! [ResultMap]).map { (value: ResultMap) -> Equipment in Equipment(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Equipment) -> ResultMap in value.resultMap }, forKey: "equipments")
        }
      }

      public struct Article: GraphQLSelectionSet {
        public static let possibleTypes = ["Article"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(ArticleTypeEnum.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("referenceID", type: .scalar(GraphQLID.self)),
          GraphQLField("unit", type: .nonNull(.scalar(ArticleUnitEnum.self))),
          GraphQLField("species", type: .scalar(SpecieEnum.self)),
          GraphQLField("variety", type: .scalar(String.self)),
          GraphQLField("marketingAuthorizationNumber", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, type: ArticleTypeEnum, name: String, referenceId: GraphQLID? = nil, unit: ArticleUnitEnum, species: SpecieEnum? = nil, variety: String? = nil, marketingAuthorizationNumber: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Article", "id": id, "type": type, "name": name, "referenceID": referenceId, "unit": unit, "species": species, "variety": variety, "marketingAuthorizationNumber": marketingAuthorizationNumber])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var type: ArticleTypeEnum {
          get {
            return resultMap["type"]! as! ArticleTypeEnum
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var referenceId: GraphQLID? {
          get {
            return resultMap["referenceID"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "referenceID")
          }
        }

        public var unit: ArticleUnitEnum {
          get {
            return resultMap["unit"]! as! ArticleUnitEnum
          }
          set {
            resultMap.updateValue(newValue, forKey: "unit")
          }
        }

        public var species: SpecieEnum? {
          get {
            return resultMap["species"] as? SpecieEnum
          }
          set {
            resultMap.updateValue(newValue, forKey: "species")
          }
        }

        public var variety: String? {
          get {
            return resultMap["variety"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "variety")
          }
        }

        public var marketingAuthorizationNumber: String? {
          get {
            return resultMap["marketingAuthorizationNumber"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "marketingAuthorizationNumber")
          }
        }
      }

      public struct Storage: GraphQLSelectionSet {
        public static let possibleTypes = ["Storage"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("type", type: .nonNull(.scalar(StorageTypeEnum.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, type: StorageTypeEnum) {
          self.init(unsafeResultMap: ["__typename": "Storage", "id": id, "name": name, "type": type])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var type: StorageTypeEnum {
          get {
            return resultMap["type"]! as! StorageTypeEnum
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }
      }

      public struct Plot: GraphQLSelectionSet {
        public static let possibleTypes = ["Plot"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("uuid", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("surfaceArea", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(uuid: String, name: String? = nil, surfaceArea: String) {
          self.init(unsafeResultMap: ["__typename": "Plot", "uuid": uuid, "name": name, "surfaceArea": surfaceArea])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var uuid: String {
          get {
            return resultMap["uuid"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "uuid")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var surfaceArea: String {
          get {
            return resultMap["surfaceArea"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "surfaceArea")
          }
        }
      }

      public struct Crop: GraphQLSelectionSet {
        public static let possibleTypes = ["Crop"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("uuid", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("species", type: .nonNull(.scalar(SpecieEnum.self))),
          GraphQLField("productionMode", type: .nonNull(.scalar(String.self))),
          GraphQLField("provisionalYield", type: .nonNull(.scalar(String.self))),
          GraphQLField("startDate", type: .scalar(String.self)),
          GraphQLField("stopDate", type: .scalar(String.self)),
          GraphQLField("surfaceArea", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(uuid: String, name: String, species: SpecieEnum, productionMode: String, provisionalYield: String, startDate: String? = nil, stopDate: String? = nil, surfaceArea: String) {
          self.init(unsafeResultMap: ["__typename": "Crop", "uuid": uuid, "name": name, "species": species, "productionMode": productionMode, "provisionalYield": provisionalYield, "startDate": startDate, "stopDate": stopDate, "surfaceArea": surfaceArea])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var uuid: String {
          get {
            return resultMap["uuid"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "uuid")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var species: SpecieEnum {
          get {
            return resultMap["species"]! as! SpecieEnum
          }
          set {
            resultMap.updateValue(newValue, forKey: "species")
          }
        }

        public var productionMode: String {
          get {
            return resultMap["productionMode"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "productionMode")
          }
        }

        public var provisionalYield: String {
          get {
            return resultMap["provisionalYield"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "provisionalYield")
          }
        }

        public var startDate: String? {
          get {
            return resultMap["startDate"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "startDate")
          }
        }

        public var stopDate: String? {
          get {
            return resultMap["stopDate"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "stopDate")
          }
        }

        public var surfaceArea: String {
          get {
            return resultMap["surfaceArea"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "surfaceArea")
          }
        }
      }

      public struct Person: GraphQLSelectionSet {
        public static let possibleTypes = ["Person"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("firstName", type: .scalar(String.self)),
          GraphQLField("lastName", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, firstName: String? = nil, lastName: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Person", "id": id, "firstName": firstName, "lastName": lastName])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var firstName: String? {
          get {
            return resultMap["firstName"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "firstName")
          }
        }

        public var lastName: String? {
          get {
            return resultMap["lastName"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "lastName")
          }
        }
      }

      public struct Equipment: GraphQLSelectionSet {
        public static let possibleTypes = ["Equipment"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("type", type: .scalar(EquipmentTypeEnum.self)),
          GraphQLField("number", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String? = nil, type: EquipmentTypeEnum? = nil, number: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Equipment", "id": id, "name": name, "type": type, "number": number])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var type: EquipmentTypeEnum? {
          get {
            return resultMap["type"] as? EquipmentTypeEnum
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var number: String? {
          get {
            return resultMap["number"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "number")
          }
        }
      }
    }
  }
}

public final class PushInterMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation pushInter($farmId: ID!, $procedure: InterventionTypeEnum!, $cropList: [InterventionTargetAttributes!]!, $workingDays: [InterventionWorkingDayAttributes!], $waterQuantity: Int, $waterUnit: InterventionWaterVolumeUnitEnum, $inputs: [InterventionInputAttributes!], $outputs: [InterventionOutputAttributes!], $globalOutputs: Boolean, $tools: [InterventionToolAttributes!], $operators: [InterventionOperatorAttributes!], $weather: WeatherAttributes, $description: String) {\n  createIntervention(input: {intervention: {farmID: $farmId, type: $procedure, targets: $cropList, workingDays: $workingDays, waterQuantity: $waterQuantity, waterUnit: $waterUnit, inputs: $inputs, outputs: $outputs, globalOutputs: $globalOutputs, tools: $tools, operators: $operators, weather: $weather, description: $description}}) {\n    __typename\n    errors\n    intervention {\n      __typename\n      id\n    }\n  }\n}"

  public var farmId: GraphQLID
  public var procedure: InterventionTypeEnum
  public var cropList: [InterventionTargetAttributes]
  public var workingDays: [InterventionWorkingDayAttributes]?
  public var waterQuantity: Int?
  public var waterUnit: InterventionWaterVolumeUnitEnum?
  public var inputs: [InterventionInputAttributes]?
  public var outputs: [InterventionOutputAttributes]?
  public var globalOutputs: Bool?
  public var tools: [InterventionToolAttributes]?
  public var operators: [InterventionOperatorAttributes]?
  public var weather: WeatherAttributes?
  public var description: String?

  public init(farmId: GraphQLID, procedure: InterventionTypeEnum, cropList: [InterventionTargetAttributes], workingDays: [InterventionWorkingDayAttributes]?, waterQuantity: Int? = nil, waterUnit: InterventionWaterVolumeUnitEnum? = nil, inputs: [InterventionInputAttributes]?, outputs: [InterventionOutputAttributes]?, globalOutputs: Bool? = nil, tools: [InterventionToolAttributes]?, operators: [InterventionOperatorAttributes]?, weather: WeatherAttributes? = nil, description: String? = nil) {
    self.farmId = farmId
    self.procedure = procedure
    self.cropList = cropList
    self.workingDays = workingDays
    self.waterQuantity = waterQuantity
    self.waterUnit = waterUnit
    self.inputs = inputs
    self.outputs = outputs
    self.globalOutputs = globalOutputs
    self.tools = tools
    self.operators = operators
    self.weather = weather
    self.description = description
  }

  public var variables: GraphQLMap? {
    return ["farmId": farmId, "procedure": procedure, "cropList": cropList, "workingDays": workingDays, "waterQuantity": waterQuantity, "waterUnit": waterUnit, "inputs": inputs, "outputs": outputs, "globalOutputs": globalOutputs, "tools": tools, "operators": operators, "weather": weather, "description": description]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createIntervention", arguments: ["input": ["intervention": ["farmID": GraphQLVariable("farmId"), "type": GraphQLVariable("procedure"), "targets": GraphQLVariable("cropList"), "workingDays": GraphQLVariable("workingDays"), "waterQuantity": GraphQLVariable("waterQuantity"), "waterUnit": GraphQLVariable("waterUnit"), "inputs": GraphQLVariable("inputs"), "outputs": GraphQLVariable("outputs"), "globalOutputs": GraphQLVariable("globalOutputs"), "tools": GraphQLVariable("tools"), "operators": GraphQLVariable("operators"), "weather": GraphQLVariable("weather"), "description": GraphQLVariable("description")]]], type: .object(CreateIntervention.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createIntervention: CreateIntervention? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createIntervention": createIntervention.flatMap { (value: CreateIntervention) -> ResultMap in value.resultMap }])
    }

    /// CreateIntervention
    public var createIntervention: CreateIntervention? {
      get {
        return (resultMap["createIntervention"] as? ResultMap).flatMap { CreateIntervention(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createIntervention")
      }
    }

    public struct CreateIntervention: GraphQLSelectionSet {
      public static let possibleTypes = ["CreateInterventionPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("errors", type: .scalar(String.self)),
        GraphQLField("intervention", type: .object(Intervention.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(errors: String? = nil, intervention: Intervention? = nil) {
        self.init(unsafeResultMap: ["__typename": "CreateInterventionPayload", "errors": errors, "intervention": intervention.flatMap { (value: Intervention) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var errors: String? {
        get {
          return resultMap["errors"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "errors")
        }
      }

      public var intervention: Intervention? {
        get {
          return (resultMap["intervention"] as? ResultMap).flatMap { Intervention(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "intervention")
        }
      }

      public struct Intervention: GraphQLSelectionSet {
        public static let possibleTypes = ["Intervention"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "Intervention", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}

public final class UpdateInterMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation updateInter($interventionId: ID!, $farmId: ID!, $procedure: InterventionTypeEnum!, $cropList: [InterventionTargetAttributes!]!, $workingDays: [InterventionWorkingDayAttributes!], $waterQuantity: Int, $waterUnit: ArticleVolumeUnitEnum, $inputs: [InterventionInputAttributes!], $outputs: [InterventionOutputAttributes!], $tools: [InterventionToolAttributes!], $operators: [InterventionOperatorAttributes!], $weather: WeatherAttributes, $description: String) {\n  updateIntervention(input: {intervention: {interventionId: $interventionId, farmID: $farmId, type: $procedure, targets: $cropList, workingDays: $workingDays, waterQuantity: $waterQuantity, waterUnit: $waterUnit, inputs: $inputs, outputs: $outputs, tools: $tools, operators: $operators, weather: $weather, description: $description}}) {\n    __typename\n    errors\n  }\n}"

  public var interventionId: GraphQLID
  public var farmId: GraphQLID
  public var procedure: InterventionTypeEnum
  public var cropList: [InterventionTargetAttributes]
  public var workingDays: [InterventionWorkingDayAttributes]?
  public var waterQuantity: Int?
  public var waterUnit: ArticleVolumeUnitEnum?
  public var inputs: [InterventionInputAttributes]?
  public var outputs: [InterventionOutputAttributes]?
  public var tools: [InterventionToolAttributes]?
  public var operators: [InterventionOperatorAttributes]?
  public var weather: WeatherAttributes?
  public var description: String?

  public init(interventionId: GraphQLID, farmId: GraphQLID, procedure: InterventionTypeEnum, cropList: [InterventionTargetAttributes], workingDays: [InterventionWorkingDayAttributes]?, waterQuantity: Int? = nil, waterUnit: ArticleVolumeUnitEnum? = nil, inputs: [InterventionInputAttributes]?, outputs: [InterventionOutputAttributes]?, tools: [InterventionToolAttributes]?, operators: [InterventionOperatorAttributes]?, weather: WeatherAttributes? = nil, description: String? = nil) {
    self.interventionId = interventionId
    self.farmId = farmId
    self.procedure = procedure
    self.cropList = cropList
    self.workingDays = workingDays
    self.waterQuantity = waterQuantity
    self.waterUnit = waterUnit
    self.inputs = inputs
    self.outputs = outputs
    self.tools = tools
    self.operators = operators
    self.weather = weather
    self.description = description
  }

  public var variables: GraphQLMap? {
    return ["interventionId": interventionId, "farmId": farmId, "procedure": procedure, "cropList": cropList, "workingDays": workingDays, "waterQuantity": waterQuantity, "waterUnit": waterUnit, "inputs": inputs, "outputs": outputs, "tools": tools, "operators": operators, "weather": weather, "description": description]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateIntervention", arguments: ["input": ["intervention": ["interventionId": GraphQLVariable("interventionId"), "farmID": GraphQLVariable("farmId"), "type": GraphQLVariable("procedure"), "targets": GraphQLVariable("cropList"), "workingDays": GraphQLVariable("workingDays"), "waterQuantity": GraphQLVariable("waterQuantity"), "waterUnit": GraphQLVariable("waterUnit"), "inputs": GraphQLVariable("inputs"), "outputs": GraphQLVariable("outputs"), "tools": GraphQLVariable("tools"), "operators": GraphQLVariable("operators"), "weather": GraphQLVariable("weather"), "description": GraphQLVariable("description")]]], type: .object(UpdateIntervention.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateIntervention: UpdateIntervention? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateIntervention": updateIntervention.flatMap { (value: UpdateIntervention) -> ResultMap in value.resultMap }])
    }

    /// UpdateIntervention
    public var updateIntervention: UpdateIntervention? {
      get {
        return (resultMap["updateIntervention"] as? ResultMap).flatMap { UpdateIntervention(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateIntervention")
      }
    }

    public struct UpdateIntervention: GraphQLSelectionSet {
      public static let possibleTypes = ["UpdateInterventionPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("errors", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(errors: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "UpdateInterventionPayload", "errors": errors])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var errors: String? {
        get {
          return resultMap["errors"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "errors")
        }
      }
    }
  }
}

public final class PushEquipmentMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation pushEquipment($farmId: ID!, $type: EquipmentTypeEnum!, $name: String!, $number: String) {\n  createEquipment(input: {equipment: {farmID: $farmId, type: $type, name: $name, number: $number}}) {\n    __typename\n    errors\n    equipment {\n      __typename\n      id\n    }\n  }\n}"

  public var farmId: GraphQLID
  public var type: EquipmentTypeEnum
  public var name: String
  public var number: String?

  public init(farmId: GraphQLID, type: EquipmentTypeEnum, name: String, number: String? = nil) {
    self.farmId = farmId
    self.type = type
    self.name = name
    self.number = number
  }

  public var variables: GraphQLMap? {
    return ["farmId": farmId, "type": type, "name": name, "number": number]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createEquipment", arguments: ["input": ["equipment": ["farmID": GraphQLVariable("farmId"), "type": GraphQLVariable("type"), "name": GraphQLVariable("name"), "number": GraphQLVariable("number")]]], type: .object(CreateEquipment.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createEquipment: CreateEquipment? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createEquipment": createEquipment.flatMap { (value: CreateEquipment) -> ResultMap in value.resultMap }])
    }

    /// CreateEquipment
    public var createEquipment: CreateEquipment? {
      get {
        return (resultMap["createEquipment"] as? ResultMap).flatMap { CreateEquipment(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createEquipment")
      }
    }

    public struct CreateEquipment: GraphQLSelectionSet {
      public static let possibleTypes = ["CreateEquipmentPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("errors", type: .scalar(String.self)),
        GraphQLField("equipment", type: .object(Equipment.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(errors: String? = nil, equipment: Equipment? = nil) {
        self.init(unsafeResultMap: ["__typename": "CreateEquipmentPayload", "errors": errors, "equipment": equipment.flatMap { (value: Equipment) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var errors: String? {
        get {
          return resultMap["errors"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "errors")
        }
      }

      public var equipment: Equipment? {
        get {
          return (resultMap["equipment"] as? ResultMap).flatMap { Equipment(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "equipment")
        }
      }

      public struct Equipment: GraphQLSelectionSet {
        public static let possibleTypes = ["Equipment"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "Equipment", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}

public final class PushArticleMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation pushArticle($farmId: ID!, $unit: ArticleUnitEnum!, $name: String!, $type: ArticleTypeEnum!, $specie: SpecieEnum, $variety: String) {\n  createArticle(input: {article: {farmID: $farmId, unit: $unit, name: $name, nature: $type, species: $specie, variety: $variety}}) {\n    __typename\n    errors\n    article {\n      __typename\n      id\n    }\n  }\n}"

  public var farmId: GraphQLID
  public var unit: ArticleUnitEnum
  public var name: String
  public var type: ArticleTypeEnum
  public var specie: SpecieEnum?
  public var variety: String?

  public init(farmId: GraphQLID, unit: ArticleUnitEnum, name: String, type: ArticleTypeEnum, specie: SpecieEnum? = nil, variety: String? = nil) {
    self.farmId = farmId
    self.unit = unit
    self.name = name
    self.type = type
    self.specie = specie
    self.variety = variety
  }

  public var variables: GraphQLMap? {
    return ["farmId": farmId, "unit": unit, "name": name, "type": type, "specie": specie, "variety": variety]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createArticle", arguments: ["input": ["article": ["farmID": GraphQLVariable("farmId"), "unit": GraphQLVariable("unit"), "name": GraphQLVariable("name"), "nature": GraphQLVariable("type"), "species": GraphQLVariable("specie"), "variety": GraphQLVariable("variety")]]], type: .object(CreateArticle.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createArticle: CreateArticle? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createArticle": createArticle.flatMap { (value: CreateArticle) -> ResultMap in value.resultMap }])
    }

    /// CreateArticle
    public var createArticle: CreateArticle? {
      get {
        return (resultMap["createArticle"] as? ResultMap).flatMap { CreateArticle(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createArticle")
      }
    }

    public struct CreateArticle: GraphQLSelectionSet {
      public static let possibleTypes = ["CreateArticlePayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("errors", type: .scalar(String.self)),
        GraphQLField("article", type: .object(Article.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(errors: String? = nil, article: Article? = nil) {
        self.init(unsafeResultMap: ["__typename": "CreateArticlePayload", "errors": errors, "article": article.flatMap { (value: Article) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var errors: String? {
        get {
          return resultMap["errors"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "errors")
        }
      }

      public var article: Article? {
        get {
          return (resultMap["article"] as? ResultMap).flatMap { Article(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "article")
        }
      }

      public struct Article: GraphQLSelectionSet {
        public static let possibleTypes = ["Article"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "Article", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}

public final class PushPersonMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation pushPerson($farmId: ID!, $firstName: String, $lastName: String!) {\n  createPerson(input: {person: {farmID: $farmId, firstName: $firstName, lastName: $lastName}}) {\n    __typename\n    errors\n    person {\n      __typename\n      id\n    }\n  }\n}"

  public var farmId: GraphQLID
  public var firstName: String?
  public var lastName: String

  public init(farmId: GraphQLID, firstName: String? = nil, lastName: String) {
    self.farmId = farmId
    self.firstName = firstName
    self.lastName = lastName
  }

  public var variables: GraphQLMap? {
    return ["farmId": farmId, "firstName": firstName, "lastName": lastName]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createPerson", arguments: ["input": ["person": ["farmID": GraphQLVariable("farmId"), "firstName": GraphQLVariable("firstName"), "lastName": GraphQLVariable("lastName")]]], type: .object(CreatePerson.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createPerson: CreatePerson? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createPerson": createPerson.flatMap { (value: CreatePerson) -> ResultMap in value.resultMap }])
    }

    /// CreatePerson: Nature field is set to 'contact'
    public var createPerson: CreatePerson? {
      get {
        return (resultMap["createPerson"] as? ResultMap).flatMap { CreatePerson(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createPerson")
      }
    }

    public struct CreatePerson: GraphQLSelectionSet {
      public static let possibleTypes = ["CreatePersonPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("errors", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("person", type: .object(Person.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(errors: [String]? = nil, person: Person? = nil) {
        self.init(unsafeResultMap: ["__typename": "CreatePersonPayload", "errors": errors, "person": person.flatMap { (value: Person) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var errors: [String]? {
        get {
          return resultMap["errors"] as? [String]
        }
        set {
          resultMap.updateValue(newValue, forKey: "errors")
        }
      }

      public var person: Person? {
        get {
          return (resultMap["person"] as? ResultMap).flatMap { Person(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "person")
        }
      }

      public struct Person: GraphQLSelectionSet {
        public static let possibleTypes = ["Person"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "Person", "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}

public final class DeleteInterMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation deleteInter($id: ID!, $farmId: ID!) {\n  deleteIntervention(input: {id: $id, farmID: $farmId}) {\n    __typename\n    errors\n    message\n  }\n}"

  public var id: GraphQLID
  public var farmId: GraphQLID

  public init(id: GraphQLID, farmId: GraphQLID) {
    self.id = id
    self.farmId = farmId
  }

  public var variables: GraphQLMap? {
    return ["id": id, "farmId": farmId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteIntervention", arguments: ["input": ["id": GraphQLVariable("id"), "farmID": GraphQLVariable("farmId")]], type: .object(DeleteIntervention.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteIntervention: DeleteIntervention? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteIntervention": deleteIntervention.flatMap { (value: DeleteIntervention) -> ResultMap in value.resultMap }])
    }

    /// DeleteIntervention
    public var deleteIntervention: DeleteIntervention? {
      get {
        return (resultMap["deleteIntervention"] as? ResultMap).flatMap { DeleteIntervention(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "deleteIntervention")
      }
    }

    public struct DeleteIntervention: GraphQLSelectionSet {
      public static let possibleTypes = ["DeleteInterventionPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("errors", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("message", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(errors: [String]? = nil, message: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "DeleteInterventionPayload", "errors": errors, "message": message])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var errors: [String]? {
        get {
          return resultMap["errors"] as? [String]
        }
        set {
          resultMap.updateValue(newValue, forKey: "errors")
        }
      }

      public var message: String? {
        get {
          return resultMap["message"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "message")
        }
      }
    }
  }
}