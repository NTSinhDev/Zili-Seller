import 'dart:convert';

class Blog {
  final int id;
  final String thumbnail;
  final String title;
  final String languageCode;
  final String description;
  final String postDate;
  Blog({
    required this.id,
    required this.thumbnail,
    required this.title,
    this.languageCode = 'vi',
    required this.description,
    required this.postDate,
  });

  static Blog get blogConstant => Blog(
        id: 1,
        thumbnail:
            "https://cdn.dribbble.com/userupload/3639911/file/original-ae545cef43334b009486d28c3471ce09.png?compress=1&resize=752x",
        title: "Tháng 6, Ta Vẫn Yêu Mưa, Nhưng Chẳng Còn Yêu Người!",
        languageCode: "vi",
        description:
            "anh nói tháng 6 có màu của nắng, màu của những ngày nắng gắt đến cháy da. Sài Gòn tháng 6, những cơn mưa dai dẳng đầu mùa như làm dịu đi tâm hồn, như ướt đẫm cả những năm tháng thanh xuân ta yêu người. Anh ơi, Sài Gòn chiều phố tháng 6 này, mưa vẫn rơi, ta vẫn yêu mưa nhưng chẳng còn yêu người. ©LeeThinh ©Thanh TuyếtCó một mùa hoa bằng lăng nở rộ, có một mùa mê đắm những cánh hoa rơi, mùa mà mình đã cùng nhau gieo thương nhớ. Sống giữa lòng thành phố, em vẫn cảm thấy cô đơn, mỗi ngày một tệ dần, cảm giác như nó đang lấn chiếm tâm hồn từng chút một. Cả thế giới của em đang thu nhỏ lại trong nỗi nhớ về anh.Mưa vẫn chưa tan, ánh đèn vẫn sáng rực cả một góc phố, một căn phòng nhỏ cô đơn vẫn mệt mỏi nép mình, Sài Gòn một tối có hơi muộn, thi thoảng ánh sáng từ màn hình điện thoại lại ánh lên, em vẫn nằm bất động ở đó, nhớ anh và đớn đau thật nhiều. Anh à, một người phụ nữ chỉ yếu đuối khi ở bên cạnh người đàn ông luôn yêu thương và chiều chuộng họ. Trong cuộc sống em bây giờ phải tự mình bươn trải với xã hội, tự lực cánh sinh rồi đối mặt với khó khăn, thử thách em phải mạnh mẽ mà vực dậy. Không có anh chàng năm xưa luôn là bờ vai đắc lực để em dựa vào, không có cánh tay luôn giang rộng ôm em vào lòng và không có những lời an ủi mật ngọt dẫn em đi ăn này uống kia để em bớt buồn nữa. Em biết rằng hiện tại và tương lai em không thể có được dù chỉ một lần. Trong căn phòng bốn bức tường này sẽ không bao giờ có sự xuất hiện của anh mà chỉ có lòng em vẫn nhớ tới anh, vẫn âm thầm chịu đựng những cảm xúc đau đớn dù biết anh chẳng xứng với những nỗi buồn mà em đã và đang phải trải qua. Em luôn cố chấp thời gian mà chúng mình đã chia tay hơn tám tháng trời rồi em vẫn luôn nhớ đến anh và tha thứ cho anh những lần anh làm em phải lo nghĩ, từng lúc buồn bã em đều tự nhắc mình phải quên đi mà anh thì em chẳng thể quên được.Trời tạnh mưa, em gạt đi nước mắt trên khóe mi, điểm lại chút phấn son trên khuôn mặt ù sầu này. Ghé vào tiệm trà hẻm nhỏ quen thuộc của chúng mình, em vẫn gọi như những ngày có anh:– Chị ơi, cho em ly trà lài nhãn lồng nhé.– Nay sao không thấy cậu bạn hay đi cùng em vậy?– Bọn em bây giờ mỗi người một nẻo rồi, em ghé tiệm thăm chị và cũng tiện để nhớ chút về anh ấy.Khẽ mỉm cười chị ấy an ủi:– Em à, mình còn trẻ, cuộc đời còn dài, hạnh phúc cuối cùng đâu phải là trạm dừng chân hiện tại. Ngước nhìn lên , em thấy những nhánh bằng lăng tím không, nó luôn là nó, luôn là vẻ đẹp nhất của hiện tại. Rồi một ngày nào đó ta sẽ tìm được một người xứng đáng hơn, nhưng bây giờ em phải là em đẹp nhất của hiện tại, thời gian và định mệnh sẽ xuôi dòng đưa em tới trạm dừng chân cuối mà em mong muốn.Nhấp chút trà lên môi, em nở một nụ cười thoải mái, em như được tiếp thêm năng lượng sau chuỗi tháng ngày không còn anh bên cạnh. Dặn lòng rồi sớm mai thức dậy em sẽ đủ mạnh mẽ để sống một cuộc đời mới, để trở thành em đẹp nhất hiện tại. Bước từng bước nhỏ, đứa mắt nhìn những nhánh bằng lăng tím sau cơn mưa dưới ánh đèn đêm Sài Gòn phố. Sau đêm nay hoa sẽ lại vươn mình đón những ánh nắng sớm mai, và những vụn vỡ trong tim em rồi sẽ tan biến.Có lẽ những thứ đẹp đẽ nhất về anh đã làm em hoài niệm suốt một quãng thời gian dài như vậy, và giờ đây anh là nhận vật trong câu chuyện ngắn do em viết tiếp. Em vẫn nhìn về phía anh, rồi anh sẽ chẳng thể nào tìm được một người yêu anh nhiều hơn em đã từng, nhưng khi trời đổ cơn mưa em sẽ không nhớ về anh và khóc vì anh nữa.Thức dậy sau một đêm dài, đêm ngủ sâu nhất trong ngần ấy tháng ngày xa anh. Em mở cửa sổ ra, ánh nắng chiếu rọi qua những nhánh bằng lăng tím, xuyên vào những mảnh rèm cửa trắng tung bay trong gió và làm xốn xao tâm hồn em, gió mang theo mùi thơm của đất mùi thơm của cỏ non mơn mởn hòa vào mùi thơm của những cánh bằng lăng tím rơi, như hòa vào dòng người tấp nập vội vã buổi sớm mai.ó một mùa hoa bằng lăng nở rộ, có một mùa mê đắm những cánh hoa rơi, mùa mà mình đã cùng nhau gieo thương nhớ. Sài Gòn tháng 6, những cơn mưa dai dẳng đầu mùa như làm dịu đi tâm hồn, như ướt đẫm cả những năm tháng thanh xuân ta yêu người. Anh ơi, Sài Gòn chiều phố tháng 6 này, mưa vẫn rơi, ta vẫn yêu mưa nhưng chẳng còn yêu người.Vẫn là một câu chuyện, là vài dòng tâm sự của bạn đọc Thanh Tuyết gửi về. Được viết mới bởi Admin(Lee Thịnh) dựa trên câu chuyện của bạn đọc gửi về. Tạm gọi là “Ta Vẫn Yêu Mưa, Nhưng Chẳng Còn Yêu Người!”Bấm theo dõi để ủng hộ chúng tôi và không bỏ lỡ bài viết mới nhất. Xin cảm ơn!",
        postDate: "14/05/2001",
      );

  Blog copyWith({
    int? id,
    String? thumbnail,
    String? title,
    String? languageCode,
    String? description,
    String? postDate,
  }) {
    return Blog(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      languageCode: languageCode ?? this.languageCode,
      description: description ?? this.description,
      postDate: postDate ?? this.postDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'thumbnail': thumbnail,
      'title': title,
      'languageCode': languageCode,
      'description': description,
      'postDate': postDate,
    };
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      id: map['id'] as int,
      thumbnail: map['thumbnail'] as String,
      title: map['vi_title'] as String,
      description: map['vi_description'] as String,
      postDate: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Blog.fromJson(String source) =>
      Blog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Blog(id: $id, thumbnail: $thumbnail, title: $title, languageCode: $languageCode, description: $description, postDate: $postDate)';
  }

  @override
  bool operator ==(covariant Blog other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.thumbnail == thumbnail &&
        other.title == title &&
        other.languageCode == languageCode &&
        other.description == description &&
        other.postDate == postDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        thumbnail.hashCode ^
        title.hashCode ^
        languageCode.hashCode ^
        description.hashCode ^
        postDate.hashCode;
  }
}
