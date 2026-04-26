abstract class SyncableRepository {
  Future<void> processPending();
  Future<void> fetchRemote();
}