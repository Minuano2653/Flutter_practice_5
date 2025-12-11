import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/discussion.dart';
import 'package:fl_prac_5/features/profile/models/user.dart';

class DiscussionsCubit extends Cubit<List<Discussion>> {
  DiscussionsCubit() : super([]) {
    _initializeDiscussions();
  }

  void _initializeDiscussions() {
    final users = [
      User(
        id: 'u1',
        name: 'Minuano',
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
      ),
      User(
        id: 'u2',
        name: 'ВладиМир',
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
      ),
      User(
        id: 'u3',
        name: 'Кто-то-Некто',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
      ),
    ];

    final discussions = [
      Discussion(
        id: 'disc1',
        title: 'А я с теплотой распродажи МегаМаркета вспоминаю... ',
        description:
            'Я помню как покупал в мегамаркете и не верил.'
            'Где же меня кинут? Когда? На 200К уже набрал и остановился.'
            'Рука дрожжала, так хотелось купить, но останавливался. А зря. Жалею теперь. '
            'Зелёные Фантики (которые сначала желтые были) не сгорели и  потихонечку ушли на бензин для всей семьи и прочие бытовые мелочи.'
            'Продукты некоторые, до сих пор еще остались (тушенка).'
            'Сделал ремонт в доме, поменял всю технику, затарился инструментами и маслами-жидкостями.'
            'Пипец повезло нам тогда. Обои и сантехнику я купил с промиком и кэшбэком 76%.'
            'Вылавливал и отрицательный кэшбэк. За немецкую сантехническую фурнитуру 102% фантиками предлагали. '
            'Фирменный слив клик-кляк в 2000р обошелся и... вернули всё зелёной кашей. До сих пор верой и правдой служит. Реально фирменный оказался. Упакован был как айфон.'
            'Пипец конечно времечко было... Но скажу честно. Боязно было. Да и мы тут друг-друга пугали что фантики сгорят. Но ведь не кинули же.'
            'Теперь, когда я читаю как дружно все ругают Сбермаркет, я про себя думаю: Ну вот хоть бы кто спасибо сказал.'
            'Вот я и подумал. Скажу я, может кто ко мне и присоединиться. Спасибо Сбермаркет тебе за ту безумную распродажу.',
        imageUrls: [
          'https://habrastorage.org/webt/zp/tm/hj/zptmhjcmudc_aorzf_nya2kfjtg.jpeg',
          'https://skillbox.ru/upload/setka_images/13030427052024_c7c2d6650fe8dd3125b1541cb39af56649bd56fa.jpg',
        ],
        author: users[0],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isInFavourites: false,
      ),
      Discussion(
        id: 'disc2',
        title: 'Советы по экономии на покупках',
        description:
            'Делимся лайфхаками, как экономить на покупках. Кэшбэк, промокоды, сезонные распродажи - все способы хороши!',
        imageUrls: [
          'https://images.unsplash.com/photo-1607863680198-23d4b2565df0?w=800',
        ],
        author: users[1],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isInFavourites: true,
      ),
      Discussion(
        id: 'disc3',
        title: 'Обсуждение новых кроссовок Nike',
        description:
            'Что думаете о новой коллекции Nike Air Max? Стоит ли своих денег? Обсудим качество и комфорт.',
        imageUrls: [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800',
          'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=800',
        ],
        author: users[2],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isInFavourites: false,
      ),
    ];

    emit(discussions);
  }

  void addDiscussion(Discussion discussion) {
    emit([discussion, ...state]);
  }

  void updateDiscussion(Discussion discussion) {
    emit(state.map((d) => d.id == discussion.id ? discussion : d).toList());
  }

  void deleteDiscussion(String id) {
    emit(state.where((d) => d.id != id).toList());
  }

  void toggleFavourite(String id) {
    emit(
      state.map((d) {
        if (d.id == id) {
          return d.copyWith(isInFavourites: !d.isInFavourites);
        }
        return d;
      }).toList(),
    );
  }

  Discussion? getDiscussionById(String id) {
    try {
      return state.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Discussion> searchDiscussions(String query) {
    if (query.isEmpty) return state;
    final lowerQuery = query.toLowerCase();
    return state
        .where((d) => d.title.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
