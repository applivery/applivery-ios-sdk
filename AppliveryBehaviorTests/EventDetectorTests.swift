import Testing
@testable import Applivery

struct EventDetectorTests {
    @Test
    func listenEvent_setsIsListeningAndStoresClosure() {
        let detector = MockEventDetector()
        var called = false
        detector.listenEvent {
            called = true
        }
        #expect(detector.isListening == true)
        #expect(detector.onDetection != nil)
        // Simulate event and check closure is called
        detector.simulateEvent()
        #expect(called == true)
    }

    @Test
    func endListening_resetsIsListeningAndClearsClosure() {
        let detector = MockEventDetector()
        detector.listenEvent { }
        detector.endListening()
        #expect(detector.isListening == false)
        #expect(detector.onDetection == nil)
    }

    @Test
    func simulateEvent_doesNotCallClosureIfNotListening() {
        let detector = MockEventDetector()
        var called = false
        detector.listenEvent {
            called = true
        }
        detector.endListening()
        detector.simulateEvent()
        #expect(called == false)
    }
}
