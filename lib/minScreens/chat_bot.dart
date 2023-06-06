import 'package:bus_client_app/message.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBot extends StatefulWidget {
  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  late DialogFlowtter dialogFlowtter;
  late DateFormat _timeFormat;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    _timeFormat = DateFormat.Hm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Center(
          child: Column(
            children: [
              Text('Customer Support'),
              SizedBox(width: 8),
              Text(
                _timeFormat.format(DateTime.now()),
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index]['message'];
                final isUserMessage = messages[index]['isUserMessage'];

                return MessageBubble(
                  message: message,
                  isUserMessage: isUserMessage,
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );

      if (response.message == null) return;

      setState(() {
        addMessage(response.message!);
      });
    }
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.insert(0, {'message': message, 'isUserMessage': isUserMessage});
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isUserMessage;

  const MessageBubble({
    required this.message,
    required this.isUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isUserMessage ? Colors.blue[200] : Colors.grey[200];
    final alignment =
        isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon = isUserMessage ? Icons.person : Icons.chat_bubble_outline;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUserMessage)
                Icon(
                  icon,
                  size: 18,
                  color: Colors.grey,
                ),
              SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.text?.text?.join('\n') ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              if (isUserMessage)
                Icon(
                  icon,
                  size: 18,
                  color: Colors.grey,
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            DateFormat.yMd().add_jm().format(DateTime.now()),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
