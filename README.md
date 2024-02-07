# Zeek-Parser-CCLinkIENoIP

English is [here](https://github.com/nttcom/zeek-parser-CCLinkIENoIP/blob/main/README_en.md)

## 概要

Zeek-Parser-CCLinkIENoIPとは[CC-Linkファミリー](https://www.cc-link.org/ja/cclink/index.html)のCC-Link IE Field、CC-Link IE ControlとCC-Link IE TSNのTSNフレームを解析できるZeekプラグインです。

## インストール

### マニュアルインストール

本プラグインを利用する前に、Zeek, Spicyがインストールされていることを確認します。

```
# Zeekのチェック
~$ zeek -version
zeek version 5.0.0

# Spicyのチェック
~$ spicyz -version
1.3.16
~$ spicyc -version
spicyc v1.5.0 (d0bc6053)

# 本マニュアルではZeekのパスが以下であることを前提としています。
~$ which zeek
/usr/local/zeek/bin/zeek
```

本リポジトリをローカル環境に `git clone` します。

```
~$ git clone https://github.com/nttcom/zeek-parser-CCLinkIENoIP.git
```

## 使い方

### マニュアルインストールの場合

ソースコードをコンパイルして、オブジェクトファイルを以下のパスにコピーします。

```
~$ cd ~/zeek-parser-CCLinkIENoIP/analyzer
~$ spicyz -o cc_link_noip.hlto cc_link_noip.spicy cc_link_noip.evt
# cc_link_noip.hltoが生成されます
~$ cp cc_link_noip.hlto /usr/local/zeek/lib/zeek-spicy/modules/
```

同様にZeekファイルを以下のパスにコピーします。

```
~$ cd ~/zeek-parser-CCLinkIENoIP/scripts/
~$ cp main.zeek /usr/local/zeek/share/zeek/site/cc_link_noip.zeek
```

最後にZeekプラグインをインポートします。

```
~$ tail /usr/local/zeek/share/zeek/site/local.zeek
...省略...
@load cc_link_noip
```

本プラグインを使うことで `cclink-ie.log`が生成されます。pcapファイルにTSNフレームのパケットが含まれる場合に `cclink-ie-tsn.log` も生成されます。

以下を実行したら、生成されるログは`cclink-ie.log`となります。
```
~$ cd ~/zeek-parser-CCLinkIENoIP/testing/Traces
~$ zeek -Cr test1.pcap /usr/local/zeek/share/zeek/site/cc_link_noip.zeek
```

以下を実行したら、生成されるログは`cclink-ie.log`と`cclink-ie-tsn.log`となります。
```
~$ zeek -Cr test2.pcap /usr/local/zeek/share/zeek/site/cc_link_noip.zeek
```

## ログのタイプと説明

### CC-Link IE FieldおよびCC-Link IE Controlの情報は`cclink-ie.log`に出力します

| フィールド | タイプ | 説明 |
| --- | --- | --- |
| ts | time | 最初に通信した時のタイムスタンプ |
| src_mac | string | 送信元MACアドレス |
| dst_mac | string | 宛先MACアドレス |
| service | string | プロトコル名 |
| pdu_type | string | プロトコルの関数名 |
| cmd | string | transient1とtransient2の特有のフィールド |
| node_type | string | ノード種別 |
| node_id | int | ノード識別子 |
| connection_info | string | transientDataの識別子 |
| src_node_number | string | 自ノード番号 |
| number | int | パケット出現回数 |
| ts_end | time | 最後に通信した時のタイムスタンプ |

`cclink-ie.log` の例は以下のとおりです。

```
#separator \x09
#set_separator	,
#empty_field	(empty)
#unset_field	-
#path	cclink-ie
#open	2023-03-15-16-56-36
#fields	ts	src_mac	dst_mac	service	pdu_type	cmd	node_type	node_id	connection_info	src_node_number	number	ts_end
#types	time	string	string	string	string	string	string	int	string	string	int	time
1658222113.678757	00:11:11:11:11:11	00:00:00:00:00:01	cclink_ie_field	offset	-	-	0	-	0x0000	25	1658222113.737340
1658222113.676554	00:11:11:11:11:11	00:00:00:00:00:01	cclink_ie_field	timer	-	-	-	-	0x0000	23	1658222113.738575
1658222113.676689	00:11:11:11:11:11	00:00:00:00:00:01	cclink_ie_field	transient1	unknownCt\x00	-	0	0x13	0x0000	29	1658222113.738687
1658222113.679981	00:11:11:11:11:11	00:00:00:00:00:01	cclink_ie_field	tokenM	-	-	0	-	0x0001	18	1658222113.732137
1658222113.676363	00:11:11:11:11:11	00:00:00:00:00:01	cclink_ie_field	ipTransient	-	-	0	0x13	0x0000	21	1658222113.735251
1658222113.677097	00:11:11:11:11:11	00:00:00:00:00:01	cclink_ie_field	cyclicDataRWr	-	-	0	-	0x0000	21	1658222113.737897
1658222113.682223	00:11:11:11:11:11	00:00:00:00:00:01	cclink_ie_field	transientAck	-	-	0	0x13	0x0000	21	1658222113.739151
1658222113.677636	00:11:11:11:11:11	00:00:00:00:00:01	cclink_ie_field	paramCheck	-	-	0	0x13	0x0000	26	1658222113.736735
1658222113.677231	00:11:11:11:11:11	00:00:00:00:00:01	cclink_ie_field	setup	-	-	1	-	0x0001	22	1658222113.736964
#close	2023-03-15-16-56-36
```

### CC-Link IE TSNの情報は`cclink-ie-tsn.log`に出力します

| フィールド | タイプ | 説明 |
| --- | --- | --- |
| ts | time | 最初に通信した時のタイムスタンプ |
| src_mac | string | 送信元MACアドレス |
| dst_mac | string | 宛先MACアドレス |
| service | string | プロトコル名 |
| flame_type | string | データフレームの名前 |
| pdu_type | string | プロトコルの関数名 |
| node_type | string | ノード種別 |
| device_type | string | 機種タイプ |
| function_name | string | 機能種別 |
| number | int | パケット出現回数 |
| ts_end | time | 最後に通信した時のタイムスタンプ |

`cclink-ie-tsn.log` の例は以下のとおりです。

```
#separator \x09
#set_separator	,
#empty_field	(empty)
#unset_field	-
#path	cclink-ie-tsn
#open	2023-11-08-08-36-11
#fields	ts	src_mac	dst_mac	service	flame_type	pdu_type	node_type	device_type	function_name	number	ts_end
#types	time	string	string	string	string	string	string	string	string	int	time
1697605189.166718	00:0c:29:a8:c1:f0	80:22:a7:83:f9:7e	cclink_ie_tsn&field	acyclic	acyclicTestDataAck	master station	-	-	30	1697605189.169635
1697605738.834423	00:0c:29:a8:c1:f0	b4:b5:2f:76:cb:e4	cclink_ie_tsn	acyclic	acyclicTestData	master station	-	-	30	1697605738.837371
1697605817.307274	00:0c:29:a8:c1:f0	00:4e:01:c5:21:8f	cclink_ie_tsn	acyclic	acyclicData	-	-	-	30	1697605817.309732
1697605837.472867	28:e9:8e:18:71:58	08:00:27:b9:d0:0b	cclink_ie_tsn	acyclic	acyclicDetection Ver.0	-	-	-	30	1697605837.475716
1697605885.372366	28:e9:8e:18:71:58	28:e9:8e:75:95:a7	cclink_ie_tsn	cyclic	cyclicM/cyclicMs	-	-	-	30	1697605885.375176
1697605875.249707	28:e9:8e:18:71:58	ff:ff:ff:ff:ff:ff	cclink_ie_tsn	acyclic	acyclicPriority	-	-	-	30	1697605875.252467
1697605857.305008	28:e9:8e:75:95:a7	28:e9:8e:18:71:58	cclink_ie_tsn	acyclic	acyclicDetectionAck Ver.1	slave station	digital I/O	srwcvpdiIR	30	1697605857.309105
1697605894.366325	28:e9:8e:75:95:a7	28:e9:8e:18:71:58	cclink_ie_tsn	cyclic	cyclicS/cyclicSs	-	-	-	30	1697605894.369247
1697605847.495273	28:e9:8e:75:95:a7	28:e9:8e:18:71:58	cclink_ie_tsn	acyclic	acyclicDetectionAck Ver.0	slave station	personal computer	srwcl	30	1697605847.499091
1697605826.702719	00:0c:29:5f:70:ce	08:00:27:b9:d0:0a	cclink_ie_tsn	acyclic	acyclicDetection Ver.0	-	-	-	30	1697605826.705461
#close	2023-11-08-08-36-11
```

## 関連ソフトウェア

本プラグインは[OsecT](https://github.com/nttcom/OsecT)で利用されています。
