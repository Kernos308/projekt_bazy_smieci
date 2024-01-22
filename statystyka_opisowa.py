import MySQLdb
import pandas as pd
import warnings

# Wyłączanie wszystkich UserWarning'ów
warnings.filterwarnings("ignore", category=UserWarning)

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'liga_pilkarska-2',
}


def liczba_bramek_rok_miesiac(rok, miesiac):
    connection = MySQLdb.connect(**db_config)
    query = f"SELECT wynik_gospodarz, wynik_gosc, data_meczu FROM mecz WHERE YEAR(data_meczu) = {rok} AND MONTH(data_meczu) = {miesiac}"
    try:
        df = pd.read_sql_query(query, connection)
        wszystkie_bramki = df['wynik_gospodarz'].sum() + df['wynik_gosc'].sum()
        print(f"Ilosc bramek w {miesiac} miesiacu roku {rok}: {wszystkie_bramki}")
    except Exception as e:
        print(f"Błąd: {e}")

    finally:
        connection.close()


def liczba_bramek_rok(rok):
    connection = MySQLdb.connect(**db_config)
    query = f"SELECT wynik_gospodarz, wynik_gosc, data_meczu FROM mecz WHERE YEAR(data_meczu) = {rok}"
    try:
        df = pd.read_sql_query(query, connection)
        wszystkie_bramki = df['wynik_gospodarz'].sum() + df['wynik_gosc'].sum()
        print(f"Ilosc bramek w roku {rok}: {wszystkie_bramki}")
    except Exception as e:
        print(f"Błąd: {e}")

    finally:
        connection.close()

def statystyka_opisowa_dla_meczu(druzyna_id, czy_gospodarz):
    connection = MySQLdb.connect(**db_config)
    if czy_gospodarz:
        query = f"SELECT wynik_gospodarz FROM mecz WHERE druzyna_gospodarz_id = {druzyna_id}"
    else:
        query = f"SELECT wynik_gosc FROM mecz WHERE druzyna_gosc_id = {druzyna_id}"

    try:
        df = pd.read_sql_query(query, connection)
        print(df.describe())
        variance = df.var()
        print(f"var     {variance}")
        median = df.median()
        print(f"median     {median}")
    except Exception as e:
        print(f"Błąd: {e}")

    finally:
        connection.close()


def statystyka_opisowa_dla_statystyk(druzyna_id, column_name):
    connection = MySQLdb.connect(**db_config)

    try:
        df = pd.read_sql_query(f"CALL PokazStatystykiZDruzynaId({druzyna_id})", connection)
        print(df[column_name].describe())
        variance = df[column_name].var()
        print(f"var     {variance}")
        median = df[column_name].median()
        print(f"median     {median}")
    except Exception as e:
        print(f"Błąd: {e}")

    finally:
        connection.close()


# statystyka_opisowa_dla_statystyk(1, 'podania')
# statystyka_opisowa_dla_meczu(1, True)
# statystyka_opisowa_dla_meczu(1, False)
# liczba_bramek_rok(2020)
# liczba_bramek_rok_miesiac(2021, 1)

