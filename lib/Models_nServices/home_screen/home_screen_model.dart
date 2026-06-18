class HomeScreenResponse {
  final bool? success;
  final HomeScreenResponseData? data;
  final String? message;

  HomeScreenResponse({this.success, this.data, this.message});

  factory HomeScreenResponse.fromJson(Map<String, dynamic> json) {
    return HomeScreenResponse(
      success: json['success'],
      data:
          json['data'] != null
              ? HomeScreenResponseData.fromJson(json['data'])
              : null,
      message: json['message'],
    );
  }
}

class HomeScreenResponseData {
  final HomeScreenUser? user;
  final HomeScreenData? homeScreen;

  HomeScreenResponseData({this.user, this.homeScreen});

  factory HomeScreenResponseData.fromJson(Map<String, dynamic> json) {
    return HomeScreenResponseData(
      user: json['user'] != null ? HomeScreenUser.fromJson(json['user']) : null,
      homeScreen:
          json['home_screen'] != null
              ? HomeScreenData.fromJson(json['home_screen'])
              : null,
    );
  }
}

class HomeScreenUser {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final int? tree;
  final int? co2;
  final int? nextTree;

  HomeScreenUser({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.tree,
    this.co2,
    this.nextTree,
  });

  factory HomeScreenUser.fromJson(Map<String, dynamic> json) {
    return HomeScreenUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      tree: json['tree'],
      co2: json['co2'],
      nextTree: json['next_tree'],
    );
  }
}

class HomeScreenData {
  final double? totalGccUnitsOwned;
  final double? currentGccUnitPrice;
  final int? treeValue;
  final int? rewardPoints;
  final int? totalCo2Impact;
  final int? nextTree;

  HomeScreenData({
    this.totalGccUnitsOwned,
    this.currentGccUnitPrice,
    this.treeValue,
    this.rewardPoints,
    this.totalCo2Impact,
    this.nextTree,
  });

  factory HomeScreenData.fromJson(Map<String, dynamic> json) {
    return HomeScreenData(
      totalGccUnitsOwned:
          json['total_gcc_units_owned'] != null
              ? (json['total_gcc_units_owned'] as num).toDouble()
              : null,

      currentGccUnitPrice:
          json['current_gcc_unit_price'] != null
              ? (json['current_gcc_unit_price'] as num).toDouble()
              : null,

      treeValue: json['tree_value'],
      rewardPoints: json['reward_points'],
      totalCo2Impact: json['total_co2_impact'],
      nextTree: json['next_tree'],
    );
  }
}