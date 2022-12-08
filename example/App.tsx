import { Pressable, StyleSheet, Text, View } from "react-native";

import * as DatePicker from "date-picker";

export default function App() {
  return (
    <View style={styles.container}>
      <Pressable
        onPress={async () => {
          const d = await DatePicker.open({
            type: "datetime",
          });
          console.log("d ", d);
        }}
      >
        <Text>Open picker</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
