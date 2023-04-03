import 'package:fb_auth_provider/providers/providers.dart';
import 'package:fb_auth_provider/repositories/profile_repository.dart';
import 'package:fb_auth_provider/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileProvider>(
      create: (context) => ProfileProvider(
        profileRepository: context.read<ProfileRepository>(),
      )..getUserProfile(
          uid: context.read<AuthProvider>().state.user!.uid,
        ),
      child: Scaffold(
        body: Consumer<ProfileProvider>(
          builder: (context, ProfileProvider profileProvider, __) {
            final state = profileProvider.state;
            if (state.profileStatus == ProfileStatus.initial) {
              return Container();
            } else if (state.profileStatus == ProfileStatus.loading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state.profileStatus == ProfileStatus.error) {
              if (state.profileStatus == ProfileStatus.error) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  errorDialog(context, state.error);
                });
              }
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/error.png',
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 20.0),
                    const Text(
                      'Oops!\nTry again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: state.user.profileImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '-id: ${state.user.id}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          '- name: ${state.user.name}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          '- email: ${state.user.email}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          '- point: ${state.user.point}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          '- rank: ${state.user.rank}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
