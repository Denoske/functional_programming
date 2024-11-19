-module(euler9_recursion).
-export([find_triplet/0, find_triplet_process/3]).

find_triplet() ->
    % Запускаем процесс для поиска тройки
    Pid = spawn(fun() -> find_triplet_process(1, 2, 997) end),
    % Ждем ответа от процесса
    receive
        {found, Product} -> Product;
        {error, Reason} -> {error, Reason}
    after 5000 -> % Тайм-аут на 5 секунд
        {error, timeout}
    end.

find_triplet_process(A, B, C) ->
    % Проверяем условия
    case A + B + C of
        1000 ->
            if A * A + B * B =:= C * C ->
                % Отправляем найденный результат обратно
                self() ! {found, A * B * C};
            true ->
                find_next(A, B, C)
            end;
        _ ->
            find_next(A, B, C)
    end.

find_next(A, B, C) ->
    % Переход к следующему состоянию
    case {B < C - 1, A < 999} of
        {true, _} ->
            % Имитация "лени" с задержкой
            timer:sleep(random:uniform(100)),
            find_triplet_process(A, B + 1, C - 1);
        {false, true} ->
            % Имитация "лени" с задержкой
            timer:sleep(random:uniform(100)),
            find_triplet_process(A + 1, A + 2, 1000 - (A + 1 + (A + 2)));
        {false, false} ->
            self() ! {error, no_triplet} % Отправляем сообщение об ошибке
    end.

